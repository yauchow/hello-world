module "vpc" {
  source = "./modules/networking/vpc"

  name        = local.environment
  environment = local.environment

  cidr_block = "10.0.0.0/16"

  region = "ap-southeast-2"

  availability_zones = [
    "ap-southeast-2a",
    "ap-southeast-2b",
  ]
}