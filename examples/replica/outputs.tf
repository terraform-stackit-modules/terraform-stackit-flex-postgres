output "instance_id" {
  description = "The ID of the replicated PostgreSQL Flex instance created by the example."
  value       = module.flex_postgres.instance_id
}
