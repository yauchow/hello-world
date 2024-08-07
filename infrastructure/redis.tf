resource "aws_iam_role" "redis_task_role" {
  name = "${substr(local.environment, 0, 42)}-redis-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  tags = {
    Environment = local.environment
  }
}

module "redis" {
  source = "./modules/ecs-tasks/ecs-service"

  config        = local.config
  environment   = local.environment
  service_name  = "redis"
  vpc           = module.vpc
  task_role_arn = aws_iam_role.redis_task_role.arn
}