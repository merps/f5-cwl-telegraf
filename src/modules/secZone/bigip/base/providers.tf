provider "bigip" {
  address = module.bigip.mgmt_public_dns[0]
  username = "admin"
  password = random_password.password.result
}