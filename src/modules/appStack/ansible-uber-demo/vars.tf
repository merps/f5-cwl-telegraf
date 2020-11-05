/*
variable "bigip" {
  type = object({
    bigip_password  = string
    bigip_mgmt_addr = list(string)
    public_nic_ids  = list(string)
  })
}

variable "aws_build" {
  type = object({
    cidr                   = string
    prefix                 = string
    keyname                = string
    random                 = string
    azs                    = list(string)
    internal_subnet_offset = number
  })
}

variable "anisble" {
  type = object({
    docker_private_ip = list(string)
    jumphost          = list(string)
  })
}
*/
variable "internal_subnet_offset" {
  default = 20
}
variable "ec2_user" {
  description = "Default ec2 user"
  default = "ubuntu"
}
variable "azs" {
  description = "testinghack"
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}
variable "bigip_admin" {
  description = "Default BIG-IP 'admin'"
  default = "admin"
}
variable "f5" {
  description = "Passed Module Object"
}
variable "aws_build" {
    description = "Passed Module Object"
}
variable "ansible" {
    description = "Passed Module Object"
}
variable "vpc" {
  description = "Passed Module Object"
}