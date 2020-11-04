# Set minimum Terraform version
terraform {
  # required_version = ">= 0.12"
}

# Source Infrastructure
data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "../infra/terraform.tfstate"
  }
}

# Create Local object for modules
locals {
  ansible = {
    docker_private_ip = data.terraform_remote_state.infra.outputs.web_tier_private_ip
    jumphost          = data.terraform_remote_state.infra.outputs.jumphost.jumphost_public_ip
  }
}

# Existing Demo stack as per GH
# TODO - well this is ugly, 1am and need to put into map and data from VPC_ID
module "ansible-uber" {
  source = "../modules/appStack/ansible-uber-demo"

  ansible   = local.ansible
  aws_build = data.terraform_remote_state.infra.outputs.aws_build
  bigip     = data.terraform_remote_state.infra.outputs.bigip
  vpc       = data.terraform_remote_state.infra.outputs.vpc
}
