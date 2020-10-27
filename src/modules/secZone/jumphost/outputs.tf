output "jumphost_public_ip" {
  description = "Public IP address of Jumpbox"
  value       = module.jumphost.public_ip
}

output "jumphost_sg_id" {
  description = "The ID of the security group"
  value       = module.jumphost_sg.*.this_security_group_id
}