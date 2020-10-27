variable "vpc" {
  type = any
}

variable "db_name_instance" {
  type    = any
  default = "gitlabhq_production"
}

variable "db_username" {
  type    = any
  default = "gitlab"
}

variable "name" {
  type    = any
  default = "gitlab"
}
/*
variable "tags" {
  type = any
}
*/
variable "jumphost_sg_id" {
  default = ""
}

variable "instance_type" {
  description = "instance type for gitlab"
  default     = "t3.medium"
}

variable "pgsql_instance_type" {
  description = "instance type for pgsql"
  default     = "db.t2.micro"
}

variable "https_trusted_ip" {
  type    = list
  default = ["0.0.0.0/0"]
}

variable "gitlab_name" {
  type    = string
  default = "gitlab"
}

variable "env" {
  description = "Project Environment"
  default = "demo"
}