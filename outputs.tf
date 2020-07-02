output "database_name" {
  description = "Name of the Athena database"
  value       = local.database_snake_case
}

output "query_ids" {
  description = "A map of query names and ids"
  value = {
    for instance in aws_athena_named_query.queries :
    instance.name => instance.id
  }
}
