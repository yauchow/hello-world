output "dns" {
  value = aws_lb.webapp_loadbalancer.dns_name
}

output "ecs_service" {
  value = aws_ecs_service.webapp_service
}