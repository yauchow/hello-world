locals {
  full_service_name = lower("${var.environment}-${var.service_name}")

  container_definition_name = local.full_service_name
}

resource "aws_lb" "webapp_loadbalancer" {
  name               = replace("${substr(var.environment, 0, 21)}-webapp-elb", "/[^a-zA-Z-0-9\\-]/", "-")
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [var.vpc.aws_resources_security_group_id]
  subnets            = var.vpc.public_subnets
  tags = {
    Name        = local.full_service_name
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
  vpc_id      = var.vpc.id

  tags = {
    Name        = local.full_service_name
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

  tags = {
    Name        = local.full_service_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "webapp_log_group" {
  name              = "/ecs/${terraform.workspace}/${var.service_name}"
  retention_in_days = 7

  tags = {
    Name        = local.full_service_name
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "webapp_task_definition" {
  family = "${var.environment}-${var.service_name}-task-definition"
  container_definitions = jsonencode([
    {
      # Must match container name used in Load Balancer
      name  = local.container_definition_name
      image = var.container_image
      environment = concat(
        [
          {
            name  = "ASPNETCORE_URLS"
            value = "http://+:${var.port}"
          }
        ],
      var.environment_variables)
      cpu       = 256
      essential = true
      # healthCheck = {
      #   command     = ["CMD-SHELL", "curl -f http://localhost:${var.port}${var.health_check_path} || exit 1"]
      #   retries     = 10
      #   startPeriod = 1
      #   timeout     = 30
      # }

      portMappings = [
        {
          name          = local.full_service_name
          protocol      = "tcp"
          containerPort = var.port
          hostPort      = var.port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.webapp_log_group.name
          "awslogs-region"        = var.vpc.region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
    }
  ])

  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.vpc.task_definition_provisioning_role_arn
  task_role_arn            = var.task_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }

  tags = {
    Name        = local.full_service_name
    Environment = var.environment
  }
}

resource "aws_ecs_service" "webapp_service" {
  name            = "${var.environment}-${var.service_name}-service"
  cluster         = var.vpc.ecs_cluster.id
  desired_count   = 1
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.webapp_task_definition.id

  load_balancer {
    # Must match container name used in Task Definition
    container_name   = local.container_definition_name
    container_port   = var.port
    target_group_arn = aws_lb_target_group.webapp_loadbalancer_target_group.arn
  }

  network_configuration {
    assign_public_ip = true

    security_groups = [
      var.vpc.aws_resources_security_group_id,
      var.vpc.http_security_group_id
    ]

    subnets = var.vpc.public_subnets
  }

  service_connect_configuration {
    enabled   = true
    namespace = var.vpc.private_namespace_arn
    service {
      client_alias {
        dns_name = local.full_service_name
        port     = var.port
      }

      discovery_name = local.full_service_name
      port_name      = local.full_service_name
    }
  }


  tags = {
    Name        = local.full_service_name
    Environment = var.environment
  }
}