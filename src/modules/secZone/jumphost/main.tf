data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "jumphost" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name           = format("%s-demo-jumphost-%s", var.context.prefix, var.context.random)
  instance_count = length(var.context.azs)

  ami                         = data.aws_ami.latest-ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t2.xlarge"
  key_name                    = var.context.ec2_kp
  monitoring                  = false
  vpc_security_group_ids      = [module.jumphost_sg.this_security_group_id]
  subnet_ids                  = var.vpc.public_subnets

  # build user_data file from template
  user_data = templatefile("${path.module}/files/userdata.tmpl", {})

  tags = {
    Terraform   = "true"
    Environment = var.context.env
    Application = var.context.prefix
  }
}

#
# Create a security group for the jumphost
#
module "jumphost_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-jumphost-%s", var.context.prefix, var.context.random)
  description = "Security group for BIG-IP Demo"
  vpc_id      = var.vpc.vpc_id

  ingress_cidr_blocks = [var.allowed_mgmt_cidr]
  ingress_rules       = ["https-443-tcp", "ssh-tcp"]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.context.env
    Application = var.context.prefix
  }
}
