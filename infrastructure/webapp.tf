# A role that defines the permissions required for the web application to run
resource "aws_iam_role" "webapp_execution_role" {
  name = "${substr(local.environment, 0, 42)}-webapp-execution-role"
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

module "webapp" {
  source = "./modules/ecs-tasks/web-application-autoscaled"

  config             = local.config
  environment        = local.environment
  vpc                = module.vpc
  execution_role_arn = aws_iam_role.webapp_execution_role.arn
  service_name       = "webapp"
}