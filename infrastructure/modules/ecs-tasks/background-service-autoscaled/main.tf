module "service" {
  source = "../background-service"

  environment     = var.environment
  service_name    = var.service_name
  vpc             = var.vpc
  container_image = "${var.config[var.service_name].container.image}:${var.config[var.service_name].container.tag}"
  task_role_arn   = var.task_role_arn
  environment_variables = concat(
    try(var.config[var.service_name].container.environment_variables, []),
    var.environment_variables
  )
}

module "autoscaling" {
  source = "../autoscaling"

  ecs_cluster = var.vpc.ecs_cluster
  ecs_service = module.service.ecs_service

  environment  = var.environment
  service_name = var.service_name

  min_capacity = var.config[var.service_name].autoscaling.min_capacity
  max_capacity = var.config[var.service_name].autoscaling.max_capacity

  scale_out = var.config[var.service_name].autoscaling.scale_out
  scale_in  = var.config[var.service_name].autoscaling.scale_in
}