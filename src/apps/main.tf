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
# Existing Demo stack as per GH
*/
module "ansible-uber-demo" {
  source = "../modules/appStack/ansible-uber-demo"

  # TODO - well this is ugly, 1am and need to put into map and data from VPC_ID
  prefix            = "${var.project}-${var.environment}"
  region            = var.region
  cidr              = var.cidr
  azs               = var.azs
  env               = var.environment
  vpcid             = data.terraform_remote_state.infra.outputs.vpc_id
  public_subnets    = data.terraform_remote_state.infra.outputs.public_subnets
  public_nic_ids    = data.terraform_remote_state.infra.outputs.public_nic_ids
  docker_private_ip = data.terraform_remote_state.infra.outputs.web_apps_docker_private_ip
  random            = data.terraform_remote_state.infra.outputs.random_id
  keyname           = data.terraform_remote_state.infra.outputs.ec2_key_name
  keyfile           = concat(data.terraform_remote_state.infra.outputs.ec2_key_name,".pem")
  bigip_mgmt_addr   = data.terraform_remote_state.infra.outputs.bigip_mgmt_public_ips
  bigip_mgmt_dns    = data.terraform_remote_state.infra.outputs.mgmt_public_dns
  bigip_password    = data.terraform_remote_state.infra.outputs.bigip_password
  bigip_private_add = data.terraform_remote_state.infra.outputs.bigip_private_addresses
}