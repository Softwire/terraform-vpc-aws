
module "subnets_private" {
  source = "./subnet"

  vpc_id             = aws_vpc.current.id
  availability_zones = var.create_private ? local.availability_zones : []
  cidr               = local.private_subnet_cidr
  name_prefix        = "${var.name_prefix}private-"
  subnet_tags        = merge(var.tags_default, var.tags_subnets)
  acl_tags           = merge(var.tags_default, var.tags_acl)
  acl_egress         = var.acl_egress_private
  acl_ingress        = var.acl_ingress_private
}

resource "aws_route_table" "private" {
  count  = local.private_subnet_count
  vpc_id = aws_vpc.current.id
  tags   = merge(tomap({Name = "${var.name_prefix}private-${local.availability_zones[count.index]}"}), var.tags_default, var.tags_route_table)
}

resource "aws_route_table_association" "private" {
  count          = local.private_subnet_count
  subnet_id      = module.subnets_private.subnet_ids[count.index]
  route_table_id = aws_route_table.private[count.index].id
}

# Point the private subnets to the NAT gateway in their respective AZ for default egress
resource "aws_route" "default_private" {
  count                  = local.ngw_count
  route_table_id         = aws_route_table.private[count.index].id
  nat_gateway_id         = aws_nat_gateway.current[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}
