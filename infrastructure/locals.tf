module "config" {
  source = "./modules/configurations/environment"
}

locals {
  environment = lower("definitiv-${terraform.workspace}")
  config      = module.config.value
}

output "config" {
  value = local.config
}