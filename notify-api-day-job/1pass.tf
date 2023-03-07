# see https://github.com/1Password/terraform-provider-onepassword/issues/72
data "onepassword_vault" "api" {
  name = "api"
}

data "onepassword_vault" "keycloak" {
  name = "keycloak"
}

data "onepassword_item" "keycloak_env" {
  vault = data.onepassword_vault.keycloak.uuid
  title = var.notify_api_job.tag
}

data "onepassword_item" "api_env" {
  vault = data.onepassword_vault.api.uuid
  title = var.notify_api_job.tag
}

locals {
  notify_url = data.onepassword_item.api_env.section[index(data.onepassword_item.api_env.section.*.label, "notify-api")].field[index(data.onepassword_item.api_env.section[index(data.onepassword_item.api_env.section.*.label, "notify-api")].field.*.label, "notify_api_url")].value
  client = data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "entity-notebook-service-account")].field[index(data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "entity-notebook-service-account")].field.*.label, "entity_notebook_service_account_client_id")].value
  secret = data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "entity-notebook-service-account")].field[index(data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "entity-notebook-service-account")].field.*.label, "entity_notebook_service_account_client_secret")].value
  kc_url = data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "base")].field[index(data.onepassword_item.keycloak_env.section[index(data.onepassword_item.keycloak_env.section.*.label, "base")].field.*.label, "keycloak_auth_token_url")].value
}
