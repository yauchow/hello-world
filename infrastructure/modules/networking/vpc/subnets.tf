module "public_network" {
  source      = "../public-network"
  environment = var.environment

  vpc                = aws_vpc.vpc
  base_cidr_block    = local.public_cidr_block
  availability_zones = local.availability_zones
}