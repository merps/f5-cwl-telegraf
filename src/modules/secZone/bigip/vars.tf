variable "vpc" {
  description = "VPC"
}
/*
variable "vpcid" {
  description = "AWS VPC Id"
}

variable "public_subnets" {
  description = "Public Subnets"
}

variable "private_subnets" {
  description = "Private Subnets"
}

variable "database_subnets" {
  description = "Database Subnets"
}

variable "cidr" {
  description = "AWS VPC CIDR Block"
}
*/
variable "azs" {
  description = "AWS Availabilty Zones"
}

variable "prefix" {
  description = "Environment Tagging Prefix"
}

variable "env" {
  description = "Project Environment"
}

variable "random" {
  description = "Instance/Environment Tag Prefix"
}

variable "keyname" {
  description = "AWS KeyPair name"
}

variable "allowed_mgmt_cidr" {
  default = "0.0.0.0/0"
}

variable "allowed_app_cidr" {
  default = "0.0.0.0/0"
}