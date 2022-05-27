data "terraform_remote_state" "bootstrap" {
  backend = "s3"
  config = {
    region = "us-west-2"
    bucket = "skillz-terraform-state-infra"
    key    = "bootstrap/terraform.tfstate"
  }
}

locals {
  account_id = data.terraform_remote_state.bootstrap.outputs.organization_accounts["skillz-cloud-gaming-prod"].id
  region     = "us-west-2"
}

provider "aws" {
  region = "us-west-2"
  assume_role {
    role_arn = "arn:aws:iam::${local.account_id}:role/cloud-gaming-ci-runner"
  }
  default_tags {
    tags = {
      "governance.skillz.com/app"    = "test-1"
      "governance.skillz.com/env"    = "prod"
      "governance.skillz.com/domain" = ""
    }
  }
}
