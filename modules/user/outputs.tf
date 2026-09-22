output "user_ids" {
  description = "Map of user key to user ID."
  value       = { for k, u in stackit_postgresflex_user.this : k => u.user_id }
}

output "usernames" {
  description = "Map of user key to username."
  value       = { for k, u in stackit_postgresflex_user.this : k => u.username }
}

output "passwords" {
  description = "Map of user key to generated password. Sensitive."
  value       = { for k, u in stackit_postgresflex_user.this : k => u.password }
  sensitive   = true
}
