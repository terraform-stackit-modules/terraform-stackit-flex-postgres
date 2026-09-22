# ─── Core ─────────────────────────────────────────────────────────────────────

variable "project_id" {
  description = "STACKIT project ID to which the PostgreSQL Flex instance, databases and users are associated."
  type        = string
}

variable "region" {
  description = "The resource region. If not defined, the provider region is used."
  type        = string
  default     = null
}

# ─── Instance ─────────────────────────────────────────────────────────────────

variable "create_instance" {
  description = "Whether to create the PostgreSQL Flex instance. Set to false to manage databases/users against an existing instance provided via `instance_id`."
  type        = bool
  default     = true
}

variable "instance_id" {
  description = "ID of an existing PostgreSQL Flex instance. Used for databases/users when `create_instance` is false."
  type        = string
  default     = null
}

variable "name" {
  description = "Instance name."
  type        = string
  default     = null
}

variable "postgres_version" {
  description = "The PostgreSQL major version, e.g. \"17\"."
  type        = string
  default     = null
}

variable "flavor_id" {
  description = "The flavor ID of the instance (e.g. \"4.8-replica\"). List available flavors with the `stackit_postgresflex_flavors` data source."
  type        = string
  default     = null
}

variable "backup_schedule" {
  description = "Cron expression for the backup schedule, e.g. \"0 0 * * *\"."
  type        = string
  default     = null
}

variable "retention_days" {
  description = "How long backups are retained, between 32 and 90 days."
  type        = number
  default     = null
}

variable "storage" {
  description = "Storage configuration for the instance: `{ class = <storage class>, size = <GB> }`. Required when `create_instance` is true."
  type = object({
    class = string
    size  = number
  })
  default = null
}

variable "network" {
  description = "Instance network configuration: `{ acl = [<CIDR>...], access_scope = \"PUBLIC\"|\"SNA\" }`."
  type = object({
    acl          = optional(list(string))
    access_scope = optional(string)
  })
  default = null
}

# ─── Databases ────────────────────────────────────────────────────────────────

variable "databases" {
  description = <<-EOT
    Map of databases to create in the instance, keyed by a stable identifier. Each value:
      - `name`  : database name.
      - `owner` : username of the database owner.
  EOT
  type = map(object({
    name  = string
    owner = string
  }))
  default = {}
}

# ─── Users ────────────────────────────────────────────────────────────────────

variable "users" {
  description = <<-EOT
    Map of users to create in the instance, keyed by a stable identifier. Each value:
      - `username`            : the user name.
      - `roles`               : set of database access roles (e.g. ["login"]).
      - `rotate_when_changed` : optional map whose change forces password rotation.
    Generated passwords are exposed via the `user_passwords` output (sensitive).
  EOT
  type = map(object({
    username            = string
    roles               = set(string)
    rotate_when_changed = optional(map(string))
  }))
  default = {}
}
