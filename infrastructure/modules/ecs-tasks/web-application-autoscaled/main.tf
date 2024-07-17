module "web_application" {
  source = "../web-application"

  environment         = var.environment
  service_name        = var.service_name
  container_image     = "${var.config[var.service_name].container.image}:${var.config[var.service_name].container.tag}"
  subnets             = var.vpc.public_subnets
  execution_role_arn  = var.execution_role_arn
  task_role_arn       = var.vpc.task_definition_provisioning_role_arn
  ecs_cluster         = var.vpc.ecs_cluster
  vpc                 = var.vpc.id
  ecr_security_group  = var.vpc.aws_resources_security_group_id
  http_security_group = var.vpc.http_security_group_id
  environment_variables = concat(
    [
      {
        name  = "ASPNETCORE_URLS"
        value = "http://+:80"
      }
    ],

    var.environment_variables
  )
}

module "web_application_autoscaling" {
  source = "../target-tracking-autoscaling"

  ecs_cluster = var.vpc.ecs_cluster
  ecs_service = module.web_application.ecs_service

  environment  = var.environment
  service_name = var.service_name
  min_capacity = var.config[var.service_name].autoscaling.min_capacity
  max_capacity = var.config[var.service_name].autoscaling.max_capacity

  cpu_utilization    = var.config[var.service_name].autoscaling.cpu_utilization
  memory_utilization = var.config[var.service_name].autoscaling.memory_utilization
}