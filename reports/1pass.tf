# see https://github.com/1Password/terraform-provider-onepassword/issues/72
data "onepassword_vault" "database" {
  name = "database"
}

data "onepassword_item" "database_env" {
  vault = data.onepassword_vault.database.uuid
  title = var.environment.tag
}

data "onepassword_vault" "api" {
  name = "api"
}

data "onepassword_vault" "keycloak" {
  name = "keycloak"
}

data "onepassword_item" "keycloak_env" {
  vault = data.onepassword_vault.keycloak.uuid
  title = var.environment.tag
}

data "onepassword_item" "api_env" {
  vault = data.onepassword_vault.api.uuid
  title = var.environment.tag
}

locals {
  pass_values = {
    for index, job in var.jobs :
      job.name => merge(
        job.vault_section != null ? {
          db_name = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field.*.label, "database_name")].value,
          oc_svc = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field.*.label, "database_host")].value,
          oc_token = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field.*.label, "database_portforward_token")].value,
          oc_namespace = data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field[index(data.onepassword_item.database_env.section[index(data.onepassword_item.database_env.section.*.label, job.vault_section)].field.*.label, "database_namespace")].value
        } : {}
      )
  }


  notify_url = data.onepassword_item.api_env.section[index(data.onepassword_item.api_env.section.*.label, "notify-api")].field[index(data.onepassword_item.api_env.section[index(data.onepassword_item.api_env.section.*.label, "notify-api")].field.*.label, "notify_api_url")].value
  client = data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "entity-notebook-service-account")].field[index(data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "entity-notebook-service-account")].field.*.label, "entity_notebook_service_account_client_id")].value
  kc_url = data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "base")].field[index(data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "base")].field.*.label, "keycloak_auth_token_url")].value
}
