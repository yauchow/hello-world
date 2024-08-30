module "private_network" {
  source = "../private-network"

  region             = var.region
  environment        = var.environment
  vpc                = aws_vpc.vpc
  availability_zones = local.availability_zones
  base_cidr_block    = local.private_cidr_block
  nat_gateway_id     = module.public_network.nat_gateway_id
}