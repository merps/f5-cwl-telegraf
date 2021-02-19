variable "management_subnet_offset" {
  default = 10
}

variable "external_subnet_offset" {
  default = 0
}

variable "internal_subnet_offset" {
  default = 20
}
/*
variable "environment" {
  description = "Project Environment"
  type = string
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
*/
# another test
variable "aws_vpc" {
  type = object({
    cidr    = string
    azs     = list(string)
    region  = string
  })
}

variable "tags" {
  type = object({
    prefix  = string
    environment     = string
    random  = string
  })
}
