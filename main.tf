provider "aws" {
  region = "us-east-1"
}

//switch state file location from local to s3
terraform {
  backend "s3" {
    bucket         = "terraform-state-rukkie-bkt"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}