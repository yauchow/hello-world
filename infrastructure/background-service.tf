# A role that defines the permissions required for the web application to run
resource "aws_iam_role" "background_service_task_role" {
  name = "${substr(local.environment, 0, 31)}-background-service-task-role"
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

resource "aws_iam_role_policy" "task_definition_provisioning_role_policy" {

  name = "${substr(local.environment, 0, 18)}-background-service-task-role-permissions"
  role = aws_iam_role.background_service_task_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl",
          "sqs:ChangeMessageVisibility",
          "sqs:ReceiveMessage",
          "sqs:DeleteQueue",
          "sqs:SendMessage",
          "sqs:CreateQueue",
          "sqs:SetQueueAttributes"
        ],
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

module "background_service" {
  source = "./modules/ecs-tasks/background-service-autoscaled"

  config        = local.config
  environment   = local.environment
  vpc           = module.vpc
  task_role_arn = aws_iam_role.background_service_task_role.arn
  service_name  = "background-service"
  environment_variables = [
    {
      name  = "MessageQueue__Namespace"
      value = "${terraform.workspace}"
    },
    {
      name = "MessageQueue__Sqs__Region"
      value = module.vpc.region
    }
  ]

}