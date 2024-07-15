resource "aws_ecs_cluster" "environment_ecs_cluster" {
  name = "Defintitiv-${terraform.workspace}-ecs-cluster"
  tags = {
    Application = "Defintitiv-${terraform.workspace}"
  }
}