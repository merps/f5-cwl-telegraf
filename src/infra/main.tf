# Set minimum Terraform version and Terraform Cloud backend
terraform {
  required_version = ">= 0.12"
}

# Create a random id
resource "random_id" "id" {
  byte_length = 2
}

# Create Local object for modules
locals {
  context = {
    prefix  = tostring("${var.client.project}-${var.client.environment}")
    azs     = var.aws_vpc_parameters.azs
    env     = var.client.environment
    random  = tostring(random_id.id.id)
    ec2_kp  = var.aws.ec2_kp
    profile = var.aws_vpc_parameters.profile
  }
}
locals {
  aws_vpc = {
    cidr   = var.aws_vpc_parameters.cidr
    azs    = var.aws_vpc_parameters.azs
    region = var.aws_vpc_parameters.region
  }
}

# Create VPC as per requirements
module "vpc" {
  source  = "../modules/awsInfra/vpc"
  aws_vpc = local.aws_vpc
  context = local.context
}

# Create BIG-IP appliance as per requirements
module "bigip" {
  source  = "../modules/secZone/bigip"
  context = local.context
  vpc     = module.vpc
}

# Create Jump host as per requirements
module "jumphost" {
  source  = "../modules/secZone/jumphost"
  context = local.context
  vpc     = module.vpc
}

# Create WebApps Tier (Private Subnets) docker host
module "web_tier" {
  source  = "../modules/appStack/docker"
  context = local.context
  tier    = module.vpc.private_subnets
  vpc     = module.vpc
}

# Create MGMT Tier (Public Subnets) docker host
module "mgmt_tier" {
  source  = "../modules/appStack/docker"
  context = local.context
  tier    = module.vpc.management_subnets
  vpc     = module.vpc
}
