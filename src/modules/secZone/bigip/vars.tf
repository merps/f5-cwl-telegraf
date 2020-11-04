variable "vpc" {
  description = "VPC"
}

variable "allowed_mgmt_cidr" {
  default = "0.0.0.0/0"
}

variable "allowed_app_cidr" {
  default = "0.0.0.0/0"
}

variable "context" {
  type = object({
    prefix  = string
    azs     = list(string)
    env     = string
    random  = string
    ec2_kp  = string
    profile = string
  })
}