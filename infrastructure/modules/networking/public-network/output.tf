output "subnets" {
  value = module.public_subnets.*.id
}

output "nat_gateway_id" {
  value = module.public_subnets[0].nat_gateway_id
}