# see https://github.com/1Password/terraform-provider-onepassword/issues/72
data "onepassword_vault" "database" {
  name = "database"
}

data "onepassword_item" "database_env" {
  vault = data.onepassword_vault.database.uuid
  title = var.job.tag
}

locals {
  db_name = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, "auth-db2")].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, "auth-db2")].field.*.label, "auth_database_name")].value
  oc_svc = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, "auth-db2")].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, "auth-db2")].field.*.label, "auth_database_host")].value
  oc_token = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, "auth-db2")].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, "auth-db2")].field.*.label, "auth_database_portforward_token")].value
  oc_namespace = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, "auth-db2")].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, "auth-db2")].field.*.label, "auth_database_namespace")].value
}
