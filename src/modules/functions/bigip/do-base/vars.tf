variable "public_nic_ids" {
  description = "BIG-IP Public NicID's"
}

variable "bigip_private_addr" {
  description = "BIG-IP Private Addresses"
}

variable "azs" {
  description = "AWS Availabilty Zones"
}

variable "random" {
  description = "Random ID generated for tagging"
}

variable "prefix" {
  description = "Combined naming prefix"
}