terraform {
  required_version = ""

  backend "s3" {
    region         = "us-west-2"
    bucket         = "skillz-terraform-state-common-infrastructure"
    key            = "cg-prod/test-1/terraform.tfstate"
    dynamodb_table = "terraform-lock"
    acl            = "bucket-owner-full-control"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4, < 5"
    }
  }
}

