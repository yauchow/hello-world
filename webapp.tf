# A role that defines the permissions required for the web application to run
resource "aws_iam_role" "webapp_execution_role" {
  name = "${local.environment}-webapp-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  tags = {
    Environment = local.environment
  }
}

module "web_application" {
  source = "./modules/ecs-tasks/web-application"

  environment = local.environment
  service_name        = "webapp"
  container_image     = "306931650323.dkr.ecr.ap-southeast-2.amazonaws.com/hello-world:${local.webapp_image_tag}"
  subnets             = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  execution_role_arn  = aws_iam_role.webapp_execution_role.arn
  task_role_arn       = aws_iam_role.task_definition_provisioning_role.arn
  ecs_cluster         = aws_ecs_cluster.environment_ecs_cluster.id
  vpc                 = aws_vpc.vpc.id
  ecr_security_group  = aws_security_group.aws_resources_security_group.id
  http_security_group = aws_security_group.environment_http_security_group.id
  environment_variables = [
    {
      name  = "ASPNETCORE_URLS"
      value = "http://+:80"
    }
  ]
}