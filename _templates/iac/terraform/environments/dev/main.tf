terraform {
  required_version = ""

  backend "s3" {
    region         = "us-west-2"
    bucket         = "skillz-terraform-state-common-infrastructure"
    key            = "cloud-gaming-dev/test-1/terraform.tfstate"
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

module "dev" {
  source = "../../modules/core"

  stack_prefix  = "cg-dev-test-1"
  region_suffix = "usw2"
  eks_cluster_name = "cg-skillz-staging-common-usw2"
  skillz_env       = "dev"
  vpc_id           = "vpc-003bbf645c0ba35c2"
}
