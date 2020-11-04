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
# Create Local object for modules
*/
locals {
  aws_vpc = {
    vpc   = data.terraform_remote_state.infra.outputs.vpc
  }
}
locals {
  big_ip = data.terraform_remote_state.infra.outputs.bigip
}
output "thing" {
  value = flatten(data.terraform_remote_state.infra.outputs.bigip["ext"]["ip"])
}
output "vpc_cidr" {
  value = local.aws_vpc.vpc.vpc_cidr_block
}
output "web_tier" {
  value = data.terraform_remote_state.infra.outputs.web_tier_private_ip
}
output "bip" {
  value = local.big_ip
}
/*
output "key" {
  value = join(".", [data.terraform_remote_state.infra.outputs.aws_build["keypair"], "pem"])
}
output "nics" {
  value = data.terraform_remote_state.infra.outputs.public_nic_ids
}

# Existing Demo stack as per GH
# TODO - well this is ugly, 1am and need to put into map and data from VPC_ID

module "ansible-uber" {
  source = "../modules/appStack/ansible-uber-demo"

  docker_private_ip = data.terraform_remote_state.infra.outputs.web_apps_ip
  public_nic_ids = data.terraform_remote_state.infra

}
*/