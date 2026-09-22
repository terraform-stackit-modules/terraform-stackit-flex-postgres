resource "stackit_postgresflex_database" "this" {
  for_each = var.databases

  project_id  = var.project_id
  region      = var.region
  instance_id = var.instance_id
  name        = each.value.name
  owner       = each.value.owner
}
