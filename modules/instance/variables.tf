variable "project_id" {
  description = "STACKIT project ID to which the instance is associated."
  type        = string
}

variable "create_instance" {
  description = "Whether to create the PostgreSQL Flex instance."
  type        = bool
  default     = true
}

variable "name" {
  description = "Instance name."
  type        = string
}

variable "postgres_version" {
  description = "The PostgreSQL major version, e.g. \"17\"."
  type        = string
}

variable "region" {
  description = "The resource region. If not defined, the provider region is used."
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
}

variable "retention_days" {
  description = "How long backups are retained, between 32 and 90 days."
  type        = number
  default     = null

  validation {
    condition     = var.retention_days == null || (coalesce(var.retention_days, 32) >= 32 && coalesce(var.retention_days, 32) <= 90)
    error_message = "retention_days must be between 32 and 90."
  }
}

variable "storage" {
  description = "Storage configuration: `{ class = <storage class>, size = <GB> }`."
  type = object({
    class = string
    size  = number
  })
}

variable "network" {
  description = "Network configuration: `{ acl = [<CIDR>...], access_scope = \"PUBLIC\"|\"SNA\" }`. Recommended to set to avoid future breaking changes."
  type = object({
    acl          = optional(list(string))
    access_scope = optional(string)
  })
  default = null
}
