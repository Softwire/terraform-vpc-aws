resource "aws_vpc" "current" {
  cidr_block = var.vpc_cidr

  instance_tenancy     = var.dedicated_instances ? "dedicated" : "default"
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(tomap({Name = "${var.name_prefix}vpc"}), var.tags_default, var.tags_vpc)
}
