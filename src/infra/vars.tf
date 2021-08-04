variable "aws_vpc_parameters" {
  type = object({
    region  = string
    azs     = list(string)
    cidr    = string
  })
}
variable "client" {
  type = object({
    name        = string
    project     = string
    environment = string
  })
}
