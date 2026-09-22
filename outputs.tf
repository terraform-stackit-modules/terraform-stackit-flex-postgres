output "instance_id" {
  description = "The ID of the PostgreSQL Flex instance (created, or the provided instance_id when create_instance is false)."
  value       = coalesce(module.instance.instance_id, var.instance_id)
}

output "host" {
  description = "The write host of the instance (null when the instance is not created by this module)."
  value       = module.instance.host
}

output "port" {
  description = "The write port of the instance (null when the instance is not created by this module)."
  value       = module.instance.port
}

output "database_ids" {
  description = "Map of database key to database ID."
  value       = module.database.database_ids
}

output "user_ids" {
  description = "Map of user key to user ID."
  value       = module.user.user_ids
}

output "user_passwords" {
  description = "Map of user key to generated password. Sensitive."
  value       = module.user.passwords
  sensitive   = true
}
