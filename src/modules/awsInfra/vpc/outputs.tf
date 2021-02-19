# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_min.vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(module.vpc_min.*.vpc_cidr_block,[""])[0]
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_min.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_min.public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc_min.database_subnets
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = module.vpc_min.intra_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc_min.nat_public_ips
}
