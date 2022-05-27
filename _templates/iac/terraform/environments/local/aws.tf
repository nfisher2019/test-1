locals {
  aws_region = "us-west-2"
}

provider "aws" {
  region                      = local.aws_region
  access_key                  = "local"
  secret_key                  = "local"
  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  endpoints {
    dynamodb = "http://localhost:${var.aws_endpoint_port}"
    sns      = "http://localhost:${var.aws_endpoint_port}"
    sqs      = "http://localhost:${var.aws_endpoint_port}"
  }
}
