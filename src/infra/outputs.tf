# Network Information
output "aws_infra" {
  description = "AWS VPC ID for the created VPC"
  value = {
    vpc_id          = module.vpc.vpc_id,
    vpc_cidr_block  = module.vpc.vpc_cidr_block,
    mgmt_subnets    = module.vpc.database_subnets,
    public_subnets  = module.vpc.private_subnets,
    private_subnets = module.vpc.private_subnets
  }
}
# Build Information
output "aws_build" {
  description = "AWS Environment Build Information"
  value = {
    random  = random_id.id.id,
    keypair = var.aws.ec2_kp,
    project = var.client.project,
    env     = var.client.environment
  }
}
# Security
# TODO - BIG-IP Password for lazy reasons, move to secure
output "f5" {
  # description = "BIG-IP instance information"
  value = module.bigip
}
output "jumphost" {
  value = module.jumphost
}
# AppStack
# TODO Spin over to ECS
output "web_tier_private_ip" {
  value = module.web_tier.docker_private_ip
}
output "mgmt_tier_private_ip" {
  value = module.mgmt_tier.docker_private_ip
}