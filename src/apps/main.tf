#
# Set minimum Terraform version and Terraform Cloud backend
#
terraform {
  # required_version = ">= 0.12"
}
/*
# Logging Common via AS3
*/
module "as3-logging" {
  source = "../modules/functions/as3-common"

  bigip_mgmt_admin = "admin"
  bigip_mgmt_passwd = module.bigip.bigip_password
  bigip_mgmt_public_ip = module.bigip.mgmt_public_dns.0
}
