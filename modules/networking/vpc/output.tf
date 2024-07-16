output "id" {
  value = aws_vpc.vpc.id
}

output "public_subnets" {
  value = [module.subnet_a.id, module.subnet_b.id]
}

output "private_subnets" {
  value = [aws_subnet.private_subnet.id]
}

output "aws_resources_security_group_id" {
  value = module.aws_resources_security_group.id
}

output "http_security_group_id" {
  value       = aws_security_group.environment_http_security_group.id
  description = "Security group that allows access from HTTP port 80"
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.environment_ecs_cluster.id
}

output "task_definition_provisioning_role_id" {
  value = aws_iam_role.task_definition_provisioning_role.id
}

output "task_definition_provisioning_role_arn" {
  value = aws_iam_role.task_definition_provisioning_role.arn
}