#
# Set minimum Terraform version and Terraform Cloud backend
#
terraform {
  # required_version = ">= 0.12"
}
#
# TODO need to update the json template so this common is out at the moment
#
data "terraform_remote_state" "iac" {
  backend = "local"

  config = {
    path = "../secure/terraform.tfstate"
  }
}

provider "bigip" {
  address  = data.terraform_remote_state.iac.outputs.bigip_mgmt_public_ips[0]
  username = "admin"
  password = data.terraform_remote_state.iac.outputs.bigip_password
}

resource "bigip_as3" "do-this" {
  as3_json = file("${path.module}/as3-common-declaration.json")
}