module "subnets_public" {
  source = "./subnet"

  vpc_id                       = aws_vpc.current.id
  availability_zones           = var.create_public ? local.availability_zones : []
  cidr                         = local.public_subnet_cidr
  name_prefix                  = "${var.name_prefix}public-"
  subnet_tags                  = merge(var.tags_default, var.tags_subnets)
  acl_tags                     = merge(var.tags_default, var.tags_acl)
  acl_egress                   = var.acl_egress_public
  acl_ingress                  = var.acl_ingress_public
  map_public_subnet_public_ips = var.map_public_subnet_public_ips
}

resource "aws_route_table" "public" {
  count  = local.public_subnet_count
  vpc_id = aws_vpc.current.id
  tags   = merge(tomap({Name = "${var.name_prefix}public-${local.availability_zones[count.index]}"}), var.tags_default, var.tags_route_table)
}

resource "aws_route_table_association" "public" {
  count          = local.public_subnet_count
  route_table_id = aws_route_table.public[count.index].id
  subnet_id      = module.subnets_public.subnet_ids[count.index]
}

# The default egress route via the internet gateway
resource "aws_route" "public_default" {
  count                  = local.public_subnet_count
  route_table_id         = aws_route_table.public[count.index].id
  gateway_id             = aws_internet_gateway.current.id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_internet_gateway" "current" {
  vpc_id = aws_vpc.current.id
  tags   = merge(tomap({Name = "${var.name_prefix}igw"}), var.tags_default, var.tags_igw)
}

resource "aws_eip" "ngw" {
  count = local.ngw_count
  vpc   = true

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "current" {
  count         = local.ngw_count
  allocation_id = aws_eip.ngw[count.index].id
  subnet_id     = module.subnets_public.subnet_ids[count.index]

  tags = merge(tomap({Name = "${var.name_prefix}ngw-${local.availability_zones[count.index]}"}), var.tags_default, var.tags_ngw)

  lifecycle {
    create_before_destroy = true
  }
}
