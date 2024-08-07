output "subnets" {
  value = module.private_subnets.*.id
}


output "aws_resources_security_group_id" {
  value = module.aws_resources_security_group.id
}

output "private_namespace_arn" {
  value = aws_service_discovery_private_dns_namespace.private.arn
}