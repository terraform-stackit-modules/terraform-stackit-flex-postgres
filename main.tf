module "instance" {
  source = "./modules/instance"

  create_instance  = var.create_instance
  project_id       = var.project_id
  region           = var.region
  name             = var.name
  postgres_version = var.postgres_version
  flavor_id        = var.flavor_id
  backup_schedule  = var.backup_schedule
  retention_days   = var.retention_days
  storage          = var.storage
  network          = var.network
}

module "database" {
  source = "./modules/database"

  project_id  = var.project_id
  region      = var.region
  instance_id = coalesce(module.instance.instance_id, var.instance_id)
  databases   = var.databases

  depends_on = [module.user]
}

module "user" {
  source = "./modules/user"

  project_id  = var.project_id
  region      = var.region
  instance_id = coalesce(module.instance.instance_id, var.instance_id)
  users       = var.users
}
