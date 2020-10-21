variable "cidr" {
  description = "Environmental VPC CIDR"
}

variable "prefix" {
  description = "Environment Tagging Prefix"
}

variable "private_subnets" {
  description = "Private Subnets"
}

variable "azs" {
  description = "AWS Availabilty Zones"
}

variable "random" {
  description = "Instance/Environment Tag Prefix"
}

variable "keyname" {
  description = "AWS KeyPair name"
}

variable "vpcid" {
  description = "AWS VPC Id"
}