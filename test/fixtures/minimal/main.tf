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
  create_database = false
  database_name   = "test-database"
}

