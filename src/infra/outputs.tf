# Network Information
output "vpc" {
  description = "AWS VPC ID for the created VPC"
  value       = module.vpc.vpc_id
}

# BIG-IP Information
output "public_nic_ids" {
  description = "BIG-IP Public ENI IDs"
  value = module.bigip.public_nic_ids
}

output "bigip_mgmt_public_ips" {
  description = "BIG-IP Public Management IPs"
  value = module.bigip.mgmt_public_ips
}

output "bigip_mgmt_port" {
  description = "BIG-IP Public Management Ports"
  value = module.bigip.bigip_mgmt_port
}

output "mgmt_public_dns" {
  description = "BIG-IP Public Management DNS"
  value = module.bigip.mgmt_public_dns
}

output "bigip_private_addresses" {
  description = "BIG-IP Internal Management IPs"
  value = module.bigip.private_addresses
}

output "bigip_password" {
  description = "BIG-IP management password"
  value       = module.bigip.bigip_password
}

# Jumpbox information
output "jumphost_ip" {
  description = "Jumpbox IP Address"
  value       = module.jumphost.jumphost_ip
}

# Instance Information
output "ec2_key_name" {
  description = "The key used to communication with ec2 instances"
  value       = var.ec2_key_name
}

output "docker-host" {
  description = "EC2 Docker Host Private IPs"
  value = module.docker.docker_private_ip
}