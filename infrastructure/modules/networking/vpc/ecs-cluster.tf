resource "aws_ecs_cluster" "environment_ecs_cluster" {
  name = "${var.environment}-ecs-cluster"
  tags = {
    Environment = var.environment
  }
}