# see https://github.com/1Password/terraform-provider-onepassword/issues/72
data "onepassword_vault" "database" {
  name = "database"
}

data "onepassword_item" "database_env" {
  vault = data.onepassword_vault.database.uuid
  title = var.environment.tag
}

locals {
  pass_values = {
    for index, job in var.jobs:
          job.name  => {
              db_name = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field.*.label, "database_name")].value
              oc_svc = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field.*.label, "database_host")].value
              oc_token = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field.*.label, "database_portforward_token")].value
              oc_namespace = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field.*.label, "database_namespace")].value
          }
  }
}
