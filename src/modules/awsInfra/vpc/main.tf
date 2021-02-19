#
# Create the VPC 
# using directions from https://clouddocs.f5.com/cloud/public/v1/aws/AWS_multiNIC.html
#
module "vpc_min" {
  count = var.create_min && !var.create_max ? 1 : 0

  source = "terraform-aws-modules/vpc/aws"
  name                 = format("%s-min-%s", var.tags.prefix, var.tags.random)
  cidr                 = var.aws_vpc_parameters.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = var.aws_vpc_parameters.azs

  # vpc public subnet used for external interface
  public_subnets = [for num in range(length(var.aws_vpc_parameters.azs)) :
    cidrsubnet(var.aws_vpc_parameters.cidr, 8, num + var.external_subnet_offset)
  ]

  # vpc private subnet used for internal 
  private_subnets = [
    for num in range(length(var.aws_vpc_parameters.azs)) :
    cidrsubnet(var.aws_vpc_parameters.cidr, 8, num + var.internal_subnet_offset)
  ]

  enable_nat_gateway = true

  # using the database subnet method since it allows a public route
  database_subnets = [
    for num in range(length(var.aws_vpc_parameters.azs)) :
    cidrsubnet(var.aws_vpc_parameters.cidr, 8, num + var.management_subnet_offset)
  ]
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  tags = {
    Name        = format("%s-min-%s", var.tags.prefix, var.tags.random)
    Terraform   = "true"
    Environment = var.tags.environment
  }
}

module "vpc_max_public" {
  count = var.create_max ? 1 : 0
  source = "terraform-aws-modules/vpc/aws"

  name                 = format("%s-max-%s", var.tags.prefix, var.tags.random)
  cidr                 = var.aws_vpc_parameters.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = var.aws_vpc_parameters.azs

  # vpc public subnet used for external interface
  public_subnets = [for num in range(length(var.aws_vpc_parameters.azs)) :
    cidrsubnet(var.aws_vpc_parameters.cidr, 8, num + var.external_subnet_offset)
  ]
  tags = {
    Name        = format("%s-max-public-%s", var.tags.prefix, var.tags.random)
    Terraform   = "true"
    Environment = var.tags.environment
  }
}

module "vpc_max_private" {
  count = var.create_max ? 1 : 0
  source = "terraform-aws-modules/vpc/aws"

  name                 = format("%s-max-%s", var.tags.prefix, var.tags.random)
  cidr                 = var.aws_vpc_parameters.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = var.aws_vpc_parameters.azs

  # vpc private subnet used for internal
  private_subnets = [
    for num in range(length(var.aws_vpc_parameters.azs)) :
    cidrsubnet(var.aws_vpc_parameters.cidr, 8, num + var.internal_subnet_offset)
  ]

  # using the database subnet method since it allows a public route
  database_subnets = [
    for num in range(length(var.aws_vpc_parameters.azs)) :
    cidrsubnet(var.aws_vpc_parameters.cidr, 8, num + var.management_subnet_offset)
  ]
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true

  tags = {
    Name        = format("%s-max-private-%s", var.tags.prefix, var.tags.random)
    Terraform   = "true"
    Environment = var.tags.environment
  }
}

module "vpc_max_management" {
  count = var.create_max ? 1 : 0
  source = "terraform-aws-modules/vpc/aws"

  name                 = format("%s-max-%s", var.tags.prefix, var.tags.random)
  cidr                 = var.aws_vpc_parameters.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = var.aws_vpc_parameters.azs

  tags = {
    Name        = format("%s-max-mgmt-%s", var.tags.prefix, var.tags.random)
    Terraform   = "true"
    Environment = var.tags.environment
  }
}