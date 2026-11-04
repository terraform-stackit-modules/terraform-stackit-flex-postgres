output "instance_id" {
  description = "The ID of the encrypted PostgreSQL Flex instance created by the example."
  value       = module.encrypted_postgres.instance_id
}

output "host" {
  description = "The write host of the encrypted instance."
  value       = module.encrypted_postgres.host
}
