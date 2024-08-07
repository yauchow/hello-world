output "id" {
  value = aws_vpc.vpc.id
}

output "region" {
  value = var.region
}

output "public_subnets" {
  value = module.public_network.subnets
}

output "private_subnets" {
  value = module.private_network.subnets
}

# output "private_route_tables" {
#   value = [aws_route_table.private.id]
# }

output "aws_resources_security_group_id" {
  value = module.private_network.aws_resources_security_group_id
}

output "http_security_group_id" {
  value       = aws_security_group.environment_http_security_group.id
  description = "Security group that allows access from HTTP port 80"
}

output "ecs_cluster" {
  value = aws_ecs_cluster.environment_ecs_cluster
}

output "task_definition_provisioning_role_id" {
  value = aws_iam_role.task_definition_provisioning_role.id
}

output "task_definition_provisioning_role_arn" {
  value = aws_iam_role.task_definition_provisioning_role.arn
}

output "private_namespace_arn" {
  value = module.private_network.private_namespace_arn
}