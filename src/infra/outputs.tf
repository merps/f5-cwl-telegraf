# Network Information
output "vpc" {
  description = "AWS VPC ID for the created VPC"
  value = {
    "vpc_id"          = module.vpc.vpc_id,
    "vpc_cidr_block"  = module.vpc.vpc_cidr_block,
    "mgmt_subnets"    = [module.vpc.database_subnets],
    "public_subnets"  = [module.vpc.private_subnets],
    "private_subnets" = [module.vpc.private_subnets]
  }
}

# Build Information
output "aws_build" {
  description = "AWS Environment Build Information"
  value = {
    "env_id" = random_id.id,
    "keypair" = var.ec2_key_name
  }
}

# BIG-IP Information
/*
output "bigip" {
  description = "BIG-IP instance information"
  value = {
    admin_pw = module.bigip.bigip_password,
    mgmt = {
      dns  = [module.bigip.mgmt_public_dns],
      eip  = [module.bigip.mgmt_public_ips],
      port = [module.bigip.bigip_mgmt_port],
      ip  = [module.bigip.mgmt_addresses]
    }
    ext = {
      public_nic_ids = [module.bigip.public_nic_ids],
      ip            = [module.bigip.public_ip]
    }
  }
}
*/
output "mgmt_public_ips" {
  description = "BIG-IP Management Public IP Addresses"
  value       = module.bigip.mgmt_public_ips
}

output "mgmt_public_dns" {
  description = "BIG-IP Management Public FQDNs"
  value       = module.bigip.mgmt_public_dns
}

output "mgmt_addresses" {
  description = "BIG-IP Management Private IPs"
  value       = module.bigip.mgmt_addresses
}

output "bigip_mgmt_port" {
  description = "BIG-IP Management Port"
  value       = module.bigip.bigip_mgmt_port
}

output "public_nic_ids" {
  description = "BIG-IP Public Subnet SelfIP ENI ID"
  value       = module.bigip.public_nic_ids
}

output "public_ip" {
  description = "BIG-IP Public Subnet SelfIPs"
  value = module.bigip.public_ip
}

output "private_addresses" {
  description = "BIG-IP Private Subnet SelfIPs"
  value       = module.bigip.private_addresses
}

output "bigip_password" {
  description = "BIG-IP management password"
  value       = module.bigip.bigip_password
}
# Jumpbox information
output "jumphost" {
  description = "Jumpbox Host"
  value = {
    "sg" = module.jumphost.jumphost_sg_id,
    "eip" = [module.jumphost.jumphost_public_ip]
  }
}
# Docker hosts
# TODO Spin over to ECS
output "webapps" {
  description = "EC2 WebApps (Private) Docker Host"
  value = {
    "ip" = [module.web_apps.docker_private_ip]
  }
}
output "mgmtapps" {
  description = "EC2 WebApps (Private) Docker Host"
  value = {
    "ip" = [module.mgmt_apps.docker_private_ip]
  }
}
