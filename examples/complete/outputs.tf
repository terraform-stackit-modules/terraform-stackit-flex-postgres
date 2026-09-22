output "instance_id" {
  description = "The ID of the PostgreSQL Flex instance created by the example."
  value       = module.flex_postgres.instance_id
}

output "database_ids" {
  description = "The database IDs created by the example."
  value       = module.flex_postgres.database_ids
}

output "user_ids" {
  description = "The user IDs created by the example."
  value       = module.flex_postgres.user_ids
}
