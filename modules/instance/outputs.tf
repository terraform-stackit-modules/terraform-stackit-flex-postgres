output "instance_id" {
  description = "The ID of the PostgreSQL Flex instance (null when create_instance is false)."
  value       = var.create_instance ? stackit_postgresflex_instance.this[0].instance_id : null
}

output "host" {
  description = "The write host of the instance (null when create_instance is false)."
  value       = var.create_instance ? stackit_postgresflex_instance.this[0].connection_info.write.host : null
}

output "port" {
  description = "The write port of the instance (null when create_instance is false)."
  value       = var.create_instance ? stackit_postgresflex_instance.this[0].connection_info.write.port : null
}
