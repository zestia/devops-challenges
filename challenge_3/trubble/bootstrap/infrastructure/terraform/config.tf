terraform {
  backend "s3" {
    region               = "us-east-1"
    bucket               = "zestia-dev-terraform-state"
    key                  = "terraform.tfstate"
    dynamodb_table       = "zestia-dev-terraform-state-lock"
    encrypt              = "true"
    workspace_key_prefix = "devops-challenge"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region                      = "us-east-1"

  default_tags {
    tags = {
      Env                   = "dev"
      Application           = "devops-challenge"
    }
  }
}