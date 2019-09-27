output "vpc_id" {
  value = aws_vpc.current.id
}

output "private_subnet_ids" {
  value = module.subnets_private.subnet_ids
}

output "public_subnet_ids" {
  value = module.subnets_public.subnet_ids
}

output "private_route_table_ids" {
  value = aws_route_table.private.*.id
}

output "public_route_table_ids" {
  value = aws_route_table.public.*.id
}

output "availability_zone_ids" {
  value = local.availability_zones
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.current.*.id
}
