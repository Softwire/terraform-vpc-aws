# AWS VPC with subnets

## Features

* Supply your own availability zones or create subnets in all available in a given region
* Optional public and private subnets with auto-calculated CIDR ranges
* Automatic NAT gateway creation in each AZ if both public and private subnets enabled.
* Optional ACLs for subnets separated by public/private and ingress/egress
* Optional global and resource-specific tags

## CIDR logic

* The given CIDR range will be split in two for private and public subnets
* The public and private ranges will be split into the minimum number of ranges to allow distinct CIDR ranges for each subnet

## Input Variables

| Variable | Description | Type | Required | Default |
|----------|-------------|:----:|:--------:|:-------:|
| name_prefix | Prefix to attach to the name of every resource. | string | yes | |
| vpc_cidr | CIDR range for the created VPC. | string | yes | |
| dedicated_instances | Whether instances in the VPC are dedicated by default or not. | bool | no | `false` |
| enable_dns_support | Flag to enable/disable an AWS-provided DNS server within the VPC. | bool | no | `true` |
| enable_dns_hostnames | Flag to enable/disable public DNS hostnames for public IP addresses of instances in the VPC. | bool | no | `false` |
| availability_zones | Availability zones for subnets. Defaults to all availability zones in the current region. | list(string) | no | See description |
| create_public | Creates public subnets in the given availability zones. Will create a NAT gateway per availability zone if private subnets enabled. | bool | no | `true` |
| create_private | Creates private subnets in the given availability zones. Will connect to public NAT gateways if public subnets also enabled. | bool | no | `true` |
| acl_ingress_private | Ingress ACL rules for all private subnets. | map | no | [See below](#default-acl-rule) |
| acl_egress_private | Egress ACL rules for all private subnets. | map | no | [See below](#default-acl-rule) |
| acl_ingress_public | Ingress ACL rules for all public subnets. | map | no | [See below](#default-acl-rule) |
| acl_egress_public | Egress ACL rules for all public subnets. | map | no | [See below](#default-acl-rule) |
| tags_default | Tags to apply to all resources. | map | no | `{}` |
| tags_subnets | Tags to apply to all subnets. | map | no | `{}` |
| tags_route_table | Tags to apply to all route tables. | map | no | `{}` |
| tags_ngw | Tags to apply to all NAT gateways. | map | no | `{}` |
| tags_igw | Tags to apply to the internet gateway. | map | no | `{}` |
| tags_acl | Tags to apply to any ACL rules created. | map | no | `{}` |


### Default ACL rule
Default ACL default rules allow all traffic:

```hcl-terraform
[
    {
      rule_no    = 100
      from_port  = 0
      to_port    = 0
      cidr_block = "0.0.0.0/0"
      action     = "ALLOW"
      protocol   = -1
    }
  ]
```

## Outputs

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

| Variable | Description | 
|----------|-------------|
| vpc_id | ID of the created VPC | 
| private_subnet_ids | IDs of the created private subnets. Empty list if `create_private = true` | 
| public_subnet_ids | IDs of the created public subnets. Empty list if `create_public = true` |
| availability_zone_ids | IDs of the availability zones in use. See `availability_zones` input for info. |
