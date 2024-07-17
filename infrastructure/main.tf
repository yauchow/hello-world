module "vpc" {
  source = "./modules/networking/vpc"

  name        = local.environment
  environment = local.environment

  cidr_block = "10.0.0.0/16"
}