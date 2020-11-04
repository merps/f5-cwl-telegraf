variable "bip" {
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