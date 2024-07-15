resource "aws_lb" "webapp_loadbalancer" {

  name            = "${var.environment}-webapp-elb"
  ip_address_type = "ipv4"
  security_groups = [var.ecr_security_group]
  subnets         = var.subnets
  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "webapp_loadbalancer_target_group" {
  health_check {
    enabled  = true
    port     = var.port
    protocol = "HTTP"
    path     = var.health_check_path
  }

  port        = var.port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "webapp_loadbalancer_listener" {
  depends_on = [aws_lb.webapp_loadbalancer, aws_lb_target_group.webapp_loadbalancer_target_group]

  default_action {
    target_group_arn = aws_lb_target_group.webapp_loadbalancer_target_group.arn
    type             = "forward"
  }

  load_balancer_arn = aws_lb.webapp_loadbalancer.arn
  port              = var.port
  protocol          = "HTTP"

}

resource "aws_cloudwatch_log_group" "webapp_log_group" {
  name              = "/ecs/${terraform.workspace}/${var.service_name}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "webapp_task_definition" {
  family = "${var.environment}-${var.service_name}-task-definition"
  container_definitions = jsonencode([
    {
      # Must match container name used in Load Balancer
      name        = "${var.environment}-${var.service_name}-container-definition"
      image       = var.container_image
      environment = var.environment_variables
      portMappings = [
        {
          containerPort = var.port
          hostPort      = var.port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.webapp_log_group.name
          "awslogs-region"        = "ap-southeast-2"
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])

  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_service" "webapp_service" {
  name            = "${var.environment}-${var.service_name}-service"
  cluster         = var.ecs_cluster
  desired_count   = 1
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.webapp_task_definition.id

  load_balancer {
    # Must match container name used in Task Definition
    container_name   = "${var.environment}-${var.service_name}-container-definition"
    container_port   = var.port
    target_group_arn = aws_lb_target_group.webapp_loadbalancer_target_group.arn
  }

  network_configuration {
    assign_public_ip = true

    security_groups = [
      var.ecr_security_group,
      var.http_security_group
    ]

    subnets = var.subnets
  }
}