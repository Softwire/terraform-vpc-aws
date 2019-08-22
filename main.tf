locals {
  # Split the VPC cidr range in two.
  # We'll use the first to sub-divide into private subnets and the second into public
  private_subnet_cidr = cidrsubnet(var.vpc_cidr, 1, 0)
  public_subnet_cidr  = cidrsubnet(var.vpc_cidr, 1, 1)

  create_ngws        = var.create_private && var.create_public
  use_all_azs        = length(var.availability_zones) == 0
  availability_zones = local.use_all_azs ? data.aws_availability_zones.available[0].zone_ids : var.availability_zones

  private_subnet_count = length(module.subnets_private.subnet_ids)
  public_subnet_count  = length(module.subnets_public.subnet_ids)

  # This will be length(azs) if both public and private enabled, and 0 otherwise
  # We want to create NAT gateways only if we have both public and private subnets
  ngw_count = min(local.public_subnet_count, local.private_subnet_count)
}

data "aws_availability_zones" "available" {
  count = local.use_all_azs ? 1 : 0
  state = "available"
}
