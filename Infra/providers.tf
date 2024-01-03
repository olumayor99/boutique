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
  access_key = "AKIA5YZA3NUC6C62KPT3"
  secret_key = "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"

  default_tags {
    tags = {
      Project     = "Test"
      Owner       = "Gredenskiy"
      Environment = "Dev"
    }
  }
}