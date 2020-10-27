variable "env" {
  description = "Project Environment"
  type = string
}

variable "management_subnet_offset" {
  default = 10
}

variable "external_subnet_offset" {
  default = 0
}

variable "internal_subnet_offset" {
  default = 20
}

variable "cidr" {
  description = "Environmental VPC CIDR"
  type = string
}

variable "prefix" {
  description = "Environment Tagging Prefix"
}

variable "azs" {
  description = "AWS Availabilty Zones"
}

variable "random" {
  description = "Instance/Environment Tag Prefix"
}