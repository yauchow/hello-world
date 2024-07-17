module "config" {
  source = "./modules/configurations/environment"
}

locals {
  environment = "Definitiv-${terraform.workspace}"
  config      = module.config.value
}

output "config" {
  value = local.config
}