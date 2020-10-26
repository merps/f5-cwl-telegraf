provider "aws" {
  alias   = "secops"
  profile = var.secops-profile
  region  = var.region
}

provider "bigip" {
  address = module.bigip.mgmt_public_dns[0]
  username = "admin"
  password = module.bigip.bigip_password
  alias = "bigip"
}