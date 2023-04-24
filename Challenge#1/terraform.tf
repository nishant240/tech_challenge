##Terraform state file management and loacking mechanism.

terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.64.0"
    }
  }

  backend "s3" {
    bucket                    = "nishant.singh.sec"
    dynamodb_table            = "terraform-lock"
    key                       = "terraform.tfstate"
    region                    = "ap-south-1"
    shared_credentials_file   = "~/.aws/credentials"
    profile                   = "techChallenge"
  }
}