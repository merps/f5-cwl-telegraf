variable "vpc" {
  description = "VPC Parent Module Object"
}

variable "f5_ami_search_name" {
  description = "Default AMI for BIG-IP"
  default = "F5 BIGIP-15.1.0.2-0.0.9 PAYG-Best 25Mbps*"
}

variable "ec2_instance_type" {
  description = "Default EC2 Instance size for BIG-IP"
  default = "c4.xlarge"
}

# TODO - where does this instance count apply, eg. HA, Cluster, etc?
variable "f5_instance_count" {
  description = "Total Instance count for BIG-IP deployment per AZ"
  default = 2
}
variable "allowed_mgmt_cidr" {
  default = "0.0.0.0/0"
}

variable "allowed_app_cidr" {
  default = "0.0.0.0/0"
}

variable "context" {
  type = object({
    prefix  = string
    azs     = list(string)
    env     = string
    random  = string
    ec2_kp  = string
    profile = string
  })
}