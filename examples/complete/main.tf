#####################################################################################
# "complete" example — self-contained, requires only `project_id`.
#
# Prod-like PostgreSQL Flex instance: restricted ACL, a longer backup retention,
# and multiple users + databases (app owns its DB, a read-only reporting user).
# Mirrors the "complete-postgres" example of terraform-aws-modules/terraform-aws-rds.
#####################################################################################

module "flex_postgres" {
  source = "../.."

  project_id       = var.project_id
  name             = "example-postgres-complete"
  postgres_version = "17"
  flavor_id        = "4.8-replica"
  backup_schedule  = "0 2 * * *"
  retention_days   = 60

  storage = {
    class = "premium-perf2-stackit"
    size  = 10
  }

  network = {
    acl = ["10.0.0.0/8"]
  }

  users = {
    app = {
      username = "app_user"
      roles    = ["login"]
    }
    reporting = {
      username = "reporting_user"
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
