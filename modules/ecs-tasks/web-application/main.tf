# resource "aws_iam_role" "task_role" {
#   name = "Definitiv-${terraform.workspace}-${var.service_name}-task-role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ecs-tasks.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })

#   tags = {
#     Application = "Defintitiv-${terraform.workspace}"
#   }
# }

# resource "aws_security_group" "ecs_security_group" {
#   name        = "Definitiv-${terraform.workspace}-${var.service_name}-security-group"
#   vpc_id      = var.vpc
#   description = "${var.protocol} access on port ${var.port} for the -${terraform.workspace} environment"
# }

# resource "aws_vpc_security_group_ingress_rule" "ecs_security_group_ingress" {
#   security_group_id = aws_security_group.ecs_security_group.id

#   ip_protocol = var.protocol
#   from_port   = var.port
#   to_port     = var.port
#   cidr_ipv4   = "0.0.0.0/0"
# }

# resource "aws_vpc_security_group_egress_rule" "ecs_security_group_egress" {
#   security_group_id = aws_security_group.ecs_security_group.id

#   ip_protocol = var.protocol
#   from_port   = var.port
#   to_port     = var.port
#   cidr_ipv4   = "0.0.0.0/0"
# }

# resource "aws_lb" "ecs_alb" {
#   name               = "Definitiv-${terraform.workspace}-${var.service_name}-ecs-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.ecs_security_group.id]
#   subnets            = var.subnets

#   tags = {
#     Name        = "Definitiv-${terraform.workspace}-${var.service_name}-ecs-alb"
#     Application = "Definitiv-${terraform.workspace}"
#   }
# }

# resource "aws_lb_target_group" "ecs_tg" {
#   name = "Definitiv-${terraform.workspace}-${var.service_name}"

#   port        = var.port
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = var.vpc

#   health_check {
#     enabled = true
#     port    = var.port
#     path    = var.health_check_path
#   }

#   tags = {
#     Name        = "Definitiv-${terraform.workspace}-${var.service_name}-ecs-target-group"
#     Application = "Definitiv-${terraform.workspace}"
#   }
# }

# resource "aws_lb_listener" "ecs_alb_listener" {
#   load_balancer_arn = aws_lb.ecs_alb.arn
#   port              = var.port
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.ecs_tg.arn
#   }

#   tags = {
#     Name        = "Definitiv-${terraform.workspace}-${var.service_name}-ecs-alb-listener"
#     Application = "Definitiv-${terraform.workspace}"
#   }
# }

# resource "aws_cloudwatch_log_group" "ecs_log_group" {
#   name              = "/ecs/${terraform.workspace}/${var.service_name}"
#   retention_in_days = 7
# }

# resource "aws_ecs_task_definition" "ecs_task_definition" {
#   family                   = "Definitiv-${terraform.workspace}-${var.service_name}-task-definition"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   task_role_arn            = aws_iam_role.task_role.arn
#   execution_role_arn       = var.execution_role_arn

#   cpu                      = 256
#   memory                   = 512

#   runtime_platform {
#     operating_system_family = "LINUX"
#     cpu_architecture        = "X86_64"
#   }

#   container_definitions = jsonencode([
#     {
#       name      = "Definitiv-${terraform.workspace}-${var.service_name}-container-definition"
#       image     = var.container_image
#       cpu       = 256
#       memory    = 512
#       essential = true

#       portMappings = [
#         {
#           containerPort = var.port
#           hostPort      = var.port
#           protocol      = "tcp"
#         }
#       ]

#       environment = var.environment_variables

#       logConfiguration = {
#         logDriver = "awslogs"
#         options = {
#           "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
#           "awslogs-region"        = "ap-southeast-2"
#           "awslogs-stream-prefix" = "ecs"
#           "awslogs-create-group"  = "true"
#         }
#       }
#     }
#   ])

#   tags = {
#     Name        = "Definitiv-${terraform.workspace}-${var.service_name}-ecs-task-definition"
#     Application = "Definitiv-${terraform.workspace}"
#   }
# }

# resource "aws_ecs_service" "ecs_service" {
#   name            = "Definitiv-${terraform.workspace}-${var.service_name}-ecs-service"
#   cluster         = var.ecs_cluster
#   task_definition = aws_ecs_task_definition.ecs_task_definition.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets = var.subnets
#     security_groups = [
#       var.ecr_security_group,
#       aws_security_group.ecs_security_group.id
#     ]
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.ecs_tg.arn
#     container_name   = "Definitiv-${terraform.workspace}-${var.service_name}-container-definition"
#     container_port   = var.port
#   }
# }

########################################################################################################################

resource "aws_lb" "webapp_loadbalancer" {

  name            = "Definitiv-${terraform.workspace}-webapp-elb"
  ip_address_type = "ipv4"
  security_groups = [var.ecr_security_group]
  subnets         = var.subnets
  tags = {
    Application = "Defintitiv-${terraform.workspace}"
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
    Application = "Defintitiv-${terraform.workspace}"
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
  family = "Defintitiv-${terraform.workspace}-${var.service_name}-task-definition"
  container_definitions = jsonencode([
    {
      name        = "Defintitiv-${terraform.workspace}-${var.service_name}-container-definition"
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
    Application = "Defintitiv-${terraform.workspace}"
  }
}

resource "aws_ecs_service" "webapp_service" {
  name            = "Defintitiv-${terraform.workspace}-${var.service_name}-service"
  cluster         = var.ecs_cluster
  desired_count   = 1
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.webapp_task_definition.id

  load_balancer {
    container_name   = "Defintitiv-${terraform.workspace}-${var.service_name}-container-definition"
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