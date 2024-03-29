output "vpc_id" {
  value = aws_vpc.current.id
}

output "private_subnet_ids" {
  value = module.subnets_private.subnet_ids
}

output "public_subnet_ids" {
  value = module.subnets_public.subnet_ids
}

output "private_cidr_blocks" {
  value = module.subnets_private.cidr_blocks
}

output "public_cidr_blocks" {
  value = module.subnets_public.cidr_blocks
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

output "nat_gateway_public_eips" {
  value = aws_eip.ngw.*.public_ip
}

output "default_network_acl_id" {
  value = aws_vpc.current.default_network_acl_id
}