
output "bigip" {
  description = "BIG-IP instance information"
  value = {
    admin_pw = random_password.password.result,
    mgmt = {
      dns  = module.bigip.mgmt_public_dns,
      eip  = module.bigip.mgmt_public_ips,
      port = module.bigip.mgmt_port,
      ip   = flatten(module.bigip.mgmt_addresses)
    }
    ext = {
      public_nic_ids = module.bigip.public_nic_ids,
      ip             = flatten(module.bigip.public_addresses)
    }
    int = {
      ip = flatten(module.bigip.private_addresses)
    }
  }
}
