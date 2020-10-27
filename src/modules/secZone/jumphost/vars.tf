variable "env" {
  description = "Deployment Environment"
}

variable "allowed_mgmt_cidr" {
  default = "0.0.0.0/0"
}

variable "prefix" {
  description = "Environment Tagging Prefix"
}

variable "azs" {
  description = "AWS Availability Zones"
}

variable "random" {
  description = "Instance/Environment Tag Prefix"
}

variable "keyname" {
  description = "AWS KeyPair name"
}

variable "vpc" {
  description = "AWS VPC"
}