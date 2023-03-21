variable "name_prefix" {
  description = "Prefix to attach to the name of every resource."
}

# VPC variables

variable "vpc_cidr" {
  description = "CIDR range for the created VPC."
}
variable "dedicated_instances" {
  type        = bool
  default     = false
  description = "Whether instances in the VPC are dedicated by default or not."
}
variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Flag to enable/disable an AWS-provided DNS server within the VPC."
}
variable "enable_dns_hostnames" {
  type        = bool
  default     = false
  description = "Flag to enable/disable public DNS hostnames for public IP addresses of instances in the VPC."
}
variable "enable_flow_logs" {
  type        = bool
  default     = false
  description = "Flag to enable/disable VPC flow logs."
}

# Subnet variables

variable "availability_zones" {
  type        = list(string)
  default     = []
  description = "Availability zones for subnets. Defaults to all availability zones in the current region."
}

variable "create_public" {
  type        = bool
  default     = true
  description = "Creates public subnets in the given availability zones. Will create a NAT gateway per availability zone if private subnets enabled."
}

variable "map_public_subnet_public_ips" {
  type        = bool
  default     = false
  description = "Maps public subnets with public IPv4 addresses on launch."
}

variable "create_private" {
  type        = bool
  default     = true
  description = "Creates private subnets in the given availability zones. Will connect to public NAT gateways if public subnets also enabled."
}

# ACL Rules

variable "acl_ingress_private" {
  type = list(any)
  default = [
    {
      rule_no    = 100
      from_port  = 0
      to_port    = 0
      cidr_block = "0.0.0.0/0"
      action     = "ALLOW"
      protocol   = -1
    }
  ]
  description = "Ingress ACL rules for all private subnets"
}
variable "acl_egress_private" {
  type = list(any)
  default = [
    {
      rule_no    = 100
      from_port  = 0
      to_port    = 0
      cidr_block = "0.0.0.0/0"
      action     = "ALLOW"
      protocol   = -1
    }
  ]
  description = "Egress ACL rules for all private subnets"
}
variable "acl_ingress_public" {
  type = list(any)
  default = [
    {
      rule_no    = 100
      from_port  = 0
      to_port    = 0
      cidr_block = "0.0.0.0/0"
      action     = "ALLOW"
      protocol   = -1
    }
  ]
  description = "Ingress ACL rules for all public subnets"
}
variable "acl_egress_public" {
  type = list(any)
  default = [
    {
      rule_no    = 100
      from_port  = 0
      to_port    = 0
      cidr_block = "0.0.0.0/0"
      action     = "ALLOW"
      protocol   = -1
    }
  ]
  description = "Egress ACL rules for all public subnets"
}

# Tags

variable "tags_default" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all resources."
}
variable "tags_vpc" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the VPC resource."
}
variable "tags_subnets" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all subnets"
}

variable "tags_route_table" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all route tables"
}
variable "tags_ngw" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to all NAT gateways"
}
variable "tags_igw" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the internet gateway"
}
variable "tags_acl" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to any ACL rules created"
}