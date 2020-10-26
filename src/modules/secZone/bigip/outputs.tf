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
  value       = module.bigip.mgmt_port
}

output "public_nic_ids" {
  description = "BIG-IP Public Subnet SelfIP ENI ID"
  value       = module.bigip.public_nic_ids
}

output "public_ip" {
  description = "BIG-IP Public Subnet SelfIPs"
  value = module.bigip.public_addresses
}

output "private_addresses" {
  description = "BIG-IP Private Subnet SelfIPs"
  value       = module.bigip.private_addresses
}

output "bigip_password" {
  description = "BIG-IP management password"
  value       = random_password.password.result
}