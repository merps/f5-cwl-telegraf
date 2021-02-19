variable "management_subnet_offset" {
  default = 10
}

variable "external_subnet_offset" {
  default = 0
}

variable "internal_subnet_offset" {
  default = 20
}

variable "aws_vpc_parameters" {
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

variable "create_min" {
  description = "Controls if MIN VPC configuration should be created"
  type        = bool
  default     = true
}

variable "create_max" {
  description = "Controls if MIN VPC configuration should be created"
  type        = bool
  default     = false
}


