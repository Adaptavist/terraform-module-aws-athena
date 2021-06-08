module "labels" {
  source  = "cloudposse/label/terraform"
  version = "0.5.1"

  namespace = var.namespace
  stage     = var.stage
  name      = var.name
  tags      = var.tags
}

locals {
  db_name             = var.database_name != null ? var.database_name : var.bucket_name != null ? "${module.labels.id}_${var.bucket_name}_db" : ""
  database_snake_case = replace(lower(local.db_name), "-", "_")
  env                 = lower(var.stage)
}

data "aws_s3_bucket" "this" {
  count  = var.bucket_name != null ? 1 : 0
  bucket = var.bucket_name
}

resource "aws_athena_database" "this" {
  count         = var.create_database ? 1 : 0
  name          = local.database_snake_case
  bucket        = data.aws_s3_bucket.this[0].id
  force_destroy = var.database_force_destroy

  encryption_configuration {
    encryption_option = "SSE_S3"
  }
}

resource "aws_athena_named_query" "queries" {
  for_each    = var.queries
  name        = "${module.labels.id}_${each.key}"
  database    = local.database_snake_case
  description = "Query ${each.key}"
  query       = templatefile(each.value, merge({ db_name = local.database_snake_case, env = local.env }, var.query_template_parameters))
  workgroup   = (length(var.query_output_locations) == 0 ? "primary" : aws_athena_workgroup.queries[each.key].id)
}

resource "aws_athena_workgroup" "queries" {
  for_each = var.query_output_locations
  name     = "${module.labels.id}_${each.key}_workgroup"

  configuration {
    enforce_workgroup_configuration    = var.enforce_workgroup_configuration
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = each.value

      #checkov:skip=CKV_AWS_159:encryption has been considered
      #checkov:skip=CKV_AWS_82:encryption has been considered
      dynamic "encryption_configuration" {
        for_each = contains(keys(var.query_output_buckets_kms_keys), each.key) ? [true] : []
        content {
          encryption_option = "SSE_KMS"
          kms_key_arn       = var.query_output_buckets_kms_keys[each.key]
        }
      }
    }
  }
}