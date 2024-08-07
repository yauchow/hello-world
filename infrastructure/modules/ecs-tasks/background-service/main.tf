locals {
  full_service_name = lower("${var.environment}-${var.service_name}")

  container_definition_name = local.full_service_name
}

resource "aws_cloudwatch_log_group" "service_log_group" {
  name              = "/ecs/${terraform.workspace}/${var.service_name}"
  retention_in_days = 7

  tags = {
    Name        = local.full_service_name
    Environment = var.environment
  }
}

resource "aws_ecs_task_definition" "service_task_definition" {
  depends_on = [aws_cloudwatch_log_group.service_log_group]

  family = "${var.environment}-${var.service_name}-task-definition"
  container_definitions = jsonencode([
    {
      name        = local.container_definition_name
      image       = var.container_image
      environment = var.environment_variables
      cpu         = 256
      essential   = true

      # healthCheck = {
      #   command     = ["CMD-SHELL", "curl -f http://localhost:${var.port}${var.health_check_path} || exit 1"]
      #   retries     = 10
      #   startPeriod = 1
      #   timeout     = 30
      # }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.service_log_group.name
          "awslogs-region"        = var.vpc.region
          "awslogs-stream-prefix" = "ecs"
          "awslogs-create-group"  = "true"
        }
      }
      mountPoints    = []
      systemControls = []
      volumesFrom    = []
    }
  ])
  cpu                      = 256
  memory                   = 1024
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

resource "aws_ecs_service" "service" {
  name            = "${var.environment}-${var.service_name}-service"
  cluster         = var.vpc.ecs_cluster.id
  desired_count   = 1
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.service_task_definition.id
  propagate_tags  = "SERVICE"

  network_configuration {
    security_groups = [
      var.vpc.aws_resources_security_group_id
    ]

    subnets = var.vpc.private_subnets
  }

  tags = {
    Name        = local.full_service_name
    Environment = var.environment
  }
}