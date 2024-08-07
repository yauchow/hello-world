output "id" {
  value = aws_subnet.subnet.id
}

output "nat_gateway_id" {
  value = one(aws_nat_gateway.nat.*.id)
}