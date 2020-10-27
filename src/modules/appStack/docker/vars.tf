variable "env" {
  description = "Project Environment"
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

variable "keyname" {
  description = "AWS KeyPair name"
}

variable "vpc" {
  description = "AWS VPC"
}

variable "tier" {
  description = "EC2 Docker Host Tier"
}