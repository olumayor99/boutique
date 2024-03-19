terraform {
  required_version = "~> 1.0"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 3.4.2, <4.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
    graphql = {
      source  = "sullivtr/graphql"
      version = "2.5.2"
    }
  }

  backend "s3" {
    bucket         = "olatest-logger-lambda"
    key            = "terraform/new_relic/terraform_aws.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-s3-backend-locking"
    encrypt        = true
  }
}

provider "newrelic" {
  api_key    = var.new_relic_key
  account_id = var.accountId
  region     = "EU"
}

provider "aws" {
  region = "us-east-1"
}