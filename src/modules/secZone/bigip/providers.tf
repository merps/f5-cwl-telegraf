terraform {
  required_providers {
    bigip = {
      source = "F5Networks/bigip"
      version = "1.5.0"
    }
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}
