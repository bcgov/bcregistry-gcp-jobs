data "google_secret_manager_secret" "oc_token" {
  for_each     = local.pass_values
  secret_id = "OC_TOKEN_${each.value.oc_namespace}"
}

data "google_secret_manager_secret_version" "oc_token_version" {
  for_each     = local.pass_values
  secret = data.google_secret_manager_secret.oc_token[each.key].id
}

data "google_secret_manager_secret" "oc_svc" {
  for_each     = local.pass_values
  secret_id = "DB_SVC_NAME_${each.value.oc_namespace}"
}

data "google_secret_manager_secret_version" "oc_svc_version" {
  for_each     = local.pass_values
  secret = data.google_secret_manager_secret.oc_svc[each.key].id
}

data "google_secret_manager_secret" "client_secret" {
  secret_id = "NOTIFY_CLIENT_SECRET"
}

data "google_secret_manager_secret_version" "client_secret_version" {
  secret = google_secret_manager_secret.client_secret.id
}
