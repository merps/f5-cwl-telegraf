#
# Set minimum Terraform version
#
terraform {
  # required_version = ">= 0.12"
}
/*
# Source Infrastructure
*/
data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "../infra/terraform.tfstate"
  }
}
/*
output "thing" {
  value = flatten(data.terraform_remote_state.infra.outputs.bigip["ext"]["ip"])
}

output "key" {
  value = join(".", [data.terraform_remote_state.infra.outputs.aws_build["keypair"], "pem"])
}
output "nics" {
  value = data.terraform_remote_state.infra.outputs.public_nic_ids
}
/*
# Existing Demo stack as per GH
*/
module "ansible-uber-demo" {
  source = "../modules/appStack/ansible-uber-demo"

  # TODO - well this is ugly, 1am and need to put into map and data from VPC_ID

}