terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    random = {
      source = "hashicorp/random"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  alias   = "secops"
  profile = var.secops-profile
  region  = var.region
}
