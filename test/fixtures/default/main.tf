terraform {
  required_version = "~> 0.12.0"

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  version = "v2.30.0"
  region  = var.region
}

resource "aws_s3_bucket" "db" {
  bucket        = var.bucket_name
  region        = var.region
  force_destroy = true
}

resource "aws_s3_bucket" "output" {
  bucket        = "${aws_s3_bucket.db.bucket}-output"
  region        = var.region
  force_destroy = true
}

module "this" {
  source      = "../../.."
  namespace   = "adaptavist-terraform"
  stage       = "integration"
  name        = "athena-test-${aws_s3_bucket.db.bucket}"
  bucket_name = aws_s3_bucket.db.bucket
  queries = {
    "search_all" = "query.sql"
  }
  query_output_locations = {
    "search_all" = "s3://${aws_s3_bucket.output.bucket}"
  }
  query_output_buckets_kms_keys = {
    "search_all" = "arn:aws:kms:us-east-1:111122223333:alias/my-key"
  }
  database_force_destroy = true
  create_database        = true
}

