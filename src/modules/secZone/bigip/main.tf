#
# Create random password for BIG-IP
#
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
#
# Create Secret Store and Store BIG-IP Password
#
resource "aws_secretsmanager_secret" "bigip" {
  name = format("%s-bigip-secret-%s", var.prefix, var.random.hex)
}
resource "aws_secretsmanager_secret_version" "bigip-pwd" {
  secret_id     = aws_secretsmanager_secret.bigip.id
  secret_string = random_password.password.result
}
#
# Create the BIG-IP appliances
#
module "bigip" {
  source = "github.com/merps/terraform-aws-bigip?ref=ip-outputs"

  prefix                      = format("%s-bigip-3-nic_with_new_vpc-%s", var.prefix, var.random.hex)
  aws_secretmanager_secret_id = aws_secretsmanager_secret.bigip.id
  f5_ami_search_name          = "F5 BIGIP-15.1.0.2-0.0.9 PAYG-Best 25Mbps*"
  f5_instance_count           = 1
  ec2_key_name                = var.keyname
  ec2_instance_type           = "c4.xlarge"

  cloud_init = templatefile("${path.module}/files/do-declaration.tpl", {
    admin_pwd = random_password.password.result,
    root_pwd  = random_password.password.result,
    extSelfIP = join("/", [element(flatten(module.bigip.public_addresses.0), 0), 24])
    intSelfIP = join("/", [element(flatten(module.bigip.private_addresses.0), 0), 24])
    }
  )

  mgmt_subnet_security_group_ids = [
    module.bigip_sg.this_security_group_id,
    module.bigip_mgmt_sg.this_security_group_id
  ]

  public_subnet_security_group_ids = [
    module.bigip_sg.this_security_group_id,
    module.bigip_mgmt_sg.this_security_group_id
  ]

  private_subnet_security_group_ids = [
    module.bigip_sg.this_security_group_id,
    module.bigip_mgmt_sg.this_security_group_id
  ]

  vpc_public_subnet_ids  = var.public_subnets
  vpc_private_subnet_ids = var.private_subnets
  vpc_mgmt_subnet_ids    = var.database_subnets
}
#
# Create a security group for BIG-IP
#
module "bigip_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-bigip-%s", var.prefix, var.random.hex)
  description = "Security group for BIG-IP Demo"
  vpc_id      = var.vpcid

  ingress_cidr_blocks = [var.allowed_app_cidr]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigip_sg.this_security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}
#
# Create a security group for BIG-IP Management
#
module "bigip_mgmt_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-bigip-mgmt-%s", var.prefix, var.random.hex)
  description = "Security group for BIG-IP Demo"
  vpc_id      = var.vpcid

  ingress_cidr_blocks = [var.allowed_mgmt_cidr]
  ingress_rules       = ["https-443-tcp", "https-8443-tcp", "ssh-tcp"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigip_mgmt_sg.this_security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}