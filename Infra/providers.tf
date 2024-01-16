terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.24.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.12.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = "AWS-ACCESS-KEY"
  secret_key = "AWS-SECRET"

  default_tags {
    tags = {
      Project     = "Test"
      Owner       = "Gredenskiy"
      Environment = "Dev"
    }
  }
}