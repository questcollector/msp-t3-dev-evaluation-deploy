terraform {
  backend "s3" {
    bucket  = "<<s3-bucket-name>>"
    key     = "evaluation/terraform.tfstate"
    region  = "<<bucket-region>>"
    encrypt = true
  }
  required_version = ">=1.1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.aws_region
}
