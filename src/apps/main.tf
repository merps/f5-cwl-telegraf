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
module "ansible-uber-demo" {
  source = "../modules/appStack/ansible-uber-demo"
}