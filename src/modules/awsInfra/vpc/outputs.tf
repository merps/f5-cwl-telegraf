# VPC

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_min[0].vpc_id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(module.vpc_min[0].*.vpc_cidr_block,[""])[0]
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_min[0].private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc_min[0].public_subnets
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.vpc_min[0].database_subnets
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = module.vpc_min[0].intra_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc_min[0].nat_public_ips
}

# VPC
output "vpc_id_max" {
  description = "The ID of the VPC"
  value       = var.create_max ? module.vpc_max[0].vpc_id : null
}
/*
output "vpc_cidr_block_max" {
  description = "The CIDR block of the VPC"
  value       = concat(module.vpc_max[0].*.vpc_cidr_block,[""])[0]
}

# Subnets
output "private_subnets_max" {
  description = "List of IDs of private subnets"
  value       = module.vpc_max[0].private_subnets
}

output "public_subnets_max" {
  description = "List of IDs of public subnets"
  value       = module.vpc_max[0].public_subnets
}

output "database_subnets_max" {
  description = "List of IDs of database subnets"
  value       = module.vpc_max[0].database_subnets
}

output "intra_subnets_max" {
  description = "List of IDs of intra subnets"
  value       = module.vpc_max[0].intra_subnets
}

# NAT gateways
output "nat_public_ips_max" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc_max[0].nat_public_ips
}
*/