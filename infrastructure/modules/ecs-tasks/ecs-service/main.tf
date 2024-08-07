locals {
  full_service_name = lower("${var.environment}-${var.service_name}")

  container_definition_name = local.full_service_name

  container_image = "${var.config[var.service_name].container.image}:${var.config[var.service_name].container.tag}"

  container_port = var.config[var.service_name].container.container_port
  host_port      = var.config[var.service_name].container.host_port
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
      image       = local.container_image
      environment = var.environment_variables
      cpu         = 256
      essential   = true

      portMappings = [
        {
          name          = local.full_service_name
          protocol      = "tcp"
          containerPort = local.container_port
          hostPort      = local.host_port
        }
      ]

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

resource "aws_ecs_service" "service" {
  name            = local.full_service_name
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

  service_connect_configuration {
    enabled   = true
    namespace = var.vpc.private_namespace_arn
    service {
      client_alias {
        dns_name = local.full_service_name
        port     = local.host_port
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