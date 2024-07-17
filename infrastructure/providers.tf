terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "definitiv-terraform-state"
    key            = "definitiv"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform_state" # DynamoDB table used for state locking.
    encrypt        = true              # Ensures the state is encrypted at rest in S3.
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-2"
}