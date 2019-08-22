variable "vpc_id" {}
variable "cidr" {}
variable "availability_zones" {
  type = list(string)
}
variable "name_prefix" {}
variable "subnet_tags" {
  type = map(string)
}
variable "acl_tags" {
  type = map(string)
}
variable "acl_ingress" {
  type = list(any)
}
variable "acl_egress" {
  type = list(any)
}

locals {
  subnet_count = length(var.availability_zones)
  # Minimum number of binary digits to represent number of subnets we have. Catch the edge case of 0.
  subnet_newbits = local.subnet_count > 0 ? ceil(log(local.subnet_count, 2)) : 0
}

resource "aws_subnet" "current" {
  count = local.subnet_count

  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(var.cidr, local.subnet_newbits, count.index)
  availability_zone_id    = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(map("Name", "${var.name_prefix}${count.index}"), var.subnet_tags)
}

resource "aws_network_acl" "current" {
  vpc_id = var.vpc_id

  subnet_ids = aws_subnet.current.*.id
  ingress    = var.acl_ingress
  egress     = var.acl_egress

  tags = merge(map("Name", "${var.name_prefix}acl"), var.acl_tags)
}

output "subnet_ids" {
  value = aws_subnet.current.*.id
}