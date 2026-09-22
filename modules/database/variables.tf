variable "project_id" {
  description = "STACKIT project ID to which the instance is associated."
  type        = string
}

variable "instance_id" {
  description = "ID of the PostgreSQL Flex instance the databases belong to."
  type        = string
}

variable "region" {
  description = "The resource region. If not defined, the provider region is used."
  type        = string
  default     = null
}

variable "databases" {
  description = <<-EOT
    Map of databases to create, keyed by a stable identifier. Each value:
      - `name`  : database name.
      - `owner` : username of the database owner.
  EOT
  type = map(object({
    name  = string
    owner = string
  }))
  default = {}
}
