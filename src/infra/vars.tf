variable "aws" {
  type = object({
    region  = string
    azs     = list(string)
    cidr    = string
    ec2_kp  = string
    profile = string
  })
}
variable "client" {
  type = object({
    name        = string
    project     = string
    environment = string
  })
}