terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.62"
    }
  }

  required_version = ">= 1.0.4"
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

