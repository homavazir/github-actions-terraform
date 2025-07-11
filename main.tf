terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "fh-terraform-test-state"
    key            = "s3/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-lock"
    encrypt        = true

  }

}




resource "aws_s3_bucket" "example" {
  bucket        = "oidc-terraform-test-bucket-123456"
  force_destroy = true
}
