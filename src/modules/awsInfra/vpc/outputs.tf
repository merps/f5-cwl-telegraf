# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.create_min ? module.vpc_min[0].vpc_id : module.vpc_max_public[0].vpc_id
}

output private_vpc_id {
  description = "The VPC ID of the management VPC for VPC_MAX"
  value = var.create_max ? module.vpc_max_private[0].vpc_id : null
}

output "management_vpc_id" {
  description = "The VPC ID of the management VPC for VPC_MAX"
  value = var.create_max ? module.vpc_max_management[0].vpc_id : null
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = var.create_min ? concat(module.vpc_min[0].*.vpc_cidr_block,[""])[0] : concat(module.vpc_max_public[0].*.vpc_cidr_block,[""])[0]
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value = var.create_min ? module.vpc_min[0].private_subnets : module.vpc_max_private[0].private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = var.create_min ? module.vpc_min[0].public_subnets : module.vpc_max_public[0].public_subnets
}

output "management_subnets" {
  description = "List of IDs of management subnets - hack for vpc_min to be database"
  value       = var.create_min ? module.vpc_min[0].database_subnets : module.vpc_max_management[0].public_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value = var.create_min ? module.vpc_min[0].nat_public_ips : module.vpc_max_public[0].nat_public_ips
}