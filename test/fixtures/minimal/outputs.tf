output "database_name" {
  value = module.this.database_name
}

output "query_ids" {
  value = module.this.query_ids
}

output "database_bucket" {
  value = aws_s3_bucket.db.id
}

output "output_bucket" {
  value = aws_s3_bucket.output.id
}