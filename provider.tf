terraform {
  backend "s3" {
    bucket  = "terraform-state-kiyoung-2022"
    key     = "evaluation/terraform.tfstate"
    region  = "ap-northeast-2"
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
