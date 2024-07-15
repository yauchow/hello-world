# IAM role required for an ECS Service to start a new task definition
resource "aws_iam_role" "task_definition_provisioning_role" {
  name = "${local.environment}-task-defintition-provisioning-role"
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

  tags = {
    Environment = local.environment
  }
}

resource "aws_iam_role_policy" "task_definition_provisioning_role_policy" {
  name = "${local.environment}-task-defintition-provisioning-role-ecr-permissions"
  role = aws_iam_role.task_definition_provisioning_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_definition_provisioning_role_policy_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.task_definition_provisioning_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}