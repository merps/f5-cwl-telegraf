variable "bigip_mgmt_addr" {
  default = ""
}
variable "bigip_password" {
  default = ""
}
variable "keyname" {
  default = ""
}
variable "cidr" {
  default = ""
}
variable "docker_private_ip" {
  default = ""
}
variable "jumphost" {
  default = ""
}
variable "internal_subnet_offset" {
  default = 20
}
variable "prefix" {
  default = ""
}
variable "azs" {
  default = ""
}
variable "random" {
  default = ""
}
variable "public_nic_ids" {
  default = ""
}

variable "bip" {
  type = object({
    bigip_mgmt_addr       = string
    bigip_password     = string
    environment = string
  })
}