#####################################################################################
# "replica" example — self-contained, requires only `project_id`.
#
# High-availability PostgreSQL Flex. NOTE: unlike AWS RDS (which has an explicit
# `replicate_source_db`), STACKIT PostgreSQL replication is carried by the FLAVOR — a
# replicated flavor (suffix `-replica`) provisions a managed primary/replica topology.
# There is no separate "replica instance" resource to wire to a source.
#####################################################################################

module "flex_postgres" {
  source = "../.."

  project_id       = var.project_id
  name             = "example-postgres-replica"
  postgres_version = "17"

  # Replicated flavor → managed primary + replica(s) under the hood.
  flavor_id       = "4.8-replica"
  backup_schedule = "0 0 * * *"
  retention_days  = 32

  storage = {
    class = "premium-perf2-stackit"
    size  = 5
  }

  network = {
    acl = ["10.0.0.0/8"]
  }

  users = {
    app = {
      username = "app_user"
      roles    = ["login"]
    }
  }

  databases = {
    app = {
      name  = "app_db"
      owner = "app_user"
    }
  }
}
