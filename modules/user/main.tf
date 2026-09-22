resource "stackit_postgresflex_user" "this" {
  for_each = var.users

  project_id          = var.project_id
  region              = var.region
  instance_id         = var.instance_id
  username            = each.value.username
  roles               = each.value.roles
  rotate_when_changed = each.value.rotate_when_changed
}
