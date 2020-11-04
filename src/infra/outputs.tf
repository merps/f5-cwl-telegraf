# Network Information
output "vpc" {
  description = "AWS VPC ID for the created VPC"
  value = {
    vpc_id          = module.vpc.vpc_id,
    vpc_cidr_block  = module.vpc.vpc_cidr_block,
    mgmt_subnets    = [module.vpc.database_subnets],
    public_subnets  = [module.vpc.private_subnets],
    private_subnets = [module.vpc.private_subnets]
  }
}
# Build Information
output "aws_build" {
  description = "AWS Environment Build Information"
  value = {
    env_id  = random_id.id,
    keypair = var.aws.ec2_kp,
    project = var.client.project,
    env     = var.client.environment
  }
}
/*
# BIG-IP Information
*/
output "bigip" {
  description = "BIG-IP instance information"
  value = {
    admin_pw = module.bigip.bigip_password,
    mgmt = {
      dns  = [module.bigip.mgmt_public_dns],
      eip  = [module.bigip.mgmt_public_ips],
      port = [module.bigip.bigip_mgmt_port],
      ip   = [module.bigip.mgmt_addresses]
    }
    ext = {
      public_nic_ids = [module.bigip.public_nic_ids],
      ip             = [module.bigip.public_ip]
      # TODO - what the smeg, need a for_each loop?
      # bip            = zipmap(module.bigip.public_nic_ids, module.bigip.public_ip)
    }
  }
}
# Jumpbox information
output "jumphost" {
  description = "Jumpbox Host"
  value = {
    sg  = module.jumphost.jumphost_sg_id,
    eip = [module.jumphost.jumphost_public_ip]
  }
}
# Docker hosts
# TODO Spin over to ECS
output "web_tier_private_ip" {
  value = module.web_tier.docker_private_ip
}
output "mgmt_tier_private_ip" {
  value = module.mgmt_tier.docker_private_ip
}
