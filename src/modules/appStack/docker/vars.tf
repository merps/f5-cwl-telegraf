variable "vpc" {
  description = "AWS VPC"
}
variable "tier" {
  description = "EC2 Docker Host Tier"
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