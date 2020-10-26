data "aws_availability_zones" "available" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

locals {
  gitlab_zone_name = "f5cs.tech"

  db_password     = random_id.random_16[0].b64_url
  gitlab_password = random_id.random_16[1].b64_url

}
resource "random_string" "this" {
  length  = 5
  special = false
  upper   = false
}

resource "random_string" "auth_token" {
  length  = 64
  special = false
}

resource "random_id" "random_16" {
  byte_length = 16 * 3 / 4
  count       = 2
}

data "template_file" "user_data" {
  template = file("${path.module}/files/userdata.tpl")
  vars = {
    user_data_vpc_cidr        = var.vpc.vpc_cidr_block
    user_data_db_database     = module.rds_pgsql_gitlab.this_db_instance_name
    user_data_db_username     = module.rds_pgsql_gitlab.this_db_instance_username
    user_data_db_password     = module.rds_pgsql_gitlab.this_db_instance_password
    user_data_db_host         = module.rds_pgsql_gitlab.this_db_instance_address
    user_data_redis_host      = module.gitlab_redis.host
    user_data_redis_password  = random_string.auth_token.result
    user_data_gitlab_password = local.gitlab_password
    user_data_gitlab_url      = "https://${var.gitlab_name}.${local.gitlab_zone_name}"
  }
}
/*
module "gitlab_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ssh-from-bastion"
  description = "Security group for bastion host with SSH ports open within VPC"
  vpc_id      = var.vpc.vpc_id
  version     = "3.0.1"

  create = length(var.bastion_sg_id) > 0 ? true : false

  ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = var.bastion_sg_id
    }
  ]
}
*/
module "all_egress_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "all_egress"
  description = "Security group for egress"
  vpc_id      = var.vpc.vpc_id

  egress_rules       = ["all-all"]
  egress_cidr_blocks = ["0.0.0.0/0"]
}


module "gitlab_elb_https_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "https-from-trusted-ip"
  description = "Security group for gitlab with https ports open within VPC"
  vpc_id      = var.vpc.vpc_id
  version     = "3.0.1"

  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = var.https_trusted_ip

  egress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.gitlab_ec2_http_sg.this_security_group_id
    }
  ]

}


module "gitlab_ec2_http_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "https-for-gitlab-ASG"
  description = "Security group for gitlab ec2 instance with http ports open within VPC"
  vpc_id      = var.vpc.vpc_id
  version     = "3.0.1"

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.gitlab_elb_https_sg.this_security_group_id
    }
  ]
}

module "gitlab_pgsql_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "pgsql-for-gitlab-ASG"
  description = "Security group for RDS postgresql with pgsql ports open within VPC"
  vpc_id      = var.vpc.vpc_id
  version     = "3.0.1"

  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.gitlab_ec2_http_sg.this_security_group_id
    }
  ]
}


module "gitlab_redis" {
  source    = "git::https://github.com/cloudposse/terraform-aws-elasticache-redis.git?ref=master"
  namespace = var.env
  name      = "gitlab_redis"
  stage     = "dev"

  auth_token           = random_string.auth_token.result
  vpc_id               = var.vpc.vpc_id
  subnets              = var.vpc.database_subnets
  replication_group_id = var.name
  maintenance_window   = "wed:03:00-wed:04:00"
  cluster_size         = "2"
  instance_type        = "cache.t2.micro"
  engine_version       = "4.0.10"
  apply_immediately    = "true"
  availability_zones   = data.aws_availability_zones.available.names

}

module "rds_pgsql_gitlab" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.name

  engine            = "postgres"
  engine_version    = "11.2"
  instance_class    = "db.t2.micro"
  allocated_storage = 5
  storage_encrypted = false

  name     = var.db_name_instance
  username = var.db_username

  password = local.db_password
  port     = "5432"

  vpc_security_group_ids = [module.gitlab_pgsql_sg.this_security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 7

  tags = var.tags

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  subnet_ids = var.vpc.database_subnets

  family = "postgres11"

  major_engine_version = "11.2"

  final_snapshot_identifier = var.name
}