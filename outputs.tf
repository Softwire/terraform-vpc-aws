output "vpc_id" {
  value = aws_vpc.current.id
}

output "private_subnet_ids" {
  value = module.subnets_private.subnet_ids
}

output "public_subnet_ids" {
  value = module.subnets_public.subnet_ids
}

output "availability_zone_ids" {
  value = local.availability_zones
}