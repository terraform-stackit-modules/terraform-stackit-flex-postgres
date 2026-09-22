output "database_ids" {
  description = "Map of database key to database ID."
  value       = { for k, db in stackit_postgresflex_database.this : k => db.database_id }
}
