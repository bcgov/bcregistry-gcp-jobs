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
  secret = data.google_secret_manager_secret.client_secret.id
}

data "google_secret_manager_secret" "gc_secret" {
  secret_id = "GC_NOTIFY_KEY"
}

data "google_secret_manager_secret_version" "gc_secret_version" {
  secret = data.google_secret_manager_secret.gc_secret.id
}

data "google_secret_manager_secret" "virus_total_api_key" {
  secret_id = "VIRUS_TOTAL_API_KEY"
}

data "google_secret_manager_secret_version" "virus_total_api_key_version" {
  secret = data.google_secret_manager_secret.virus_total_api_key.id
}

data "google_secret_manager_secret" "bing_id_secret" {
  secret_id = "BING_ID"
}

data "google_secret_manager_secret_version" "bing_id_secret_version" {
  secret = data.google_secret_manager_secret.bing_id_secret.id
}

data "google_secret_manager_secret" "bing_api_key" {
  secret_id = "BING_API_KEY"
}

data "google_secret_manager_secret_version" "bing_api_key_version" {
  secret = data.google_secret_manager_secret.bing_api_key.id
}

data "google_secret_manager_secret" "google_api_key" {
  secret_id = "GOOGLE_API_KEY"
}

data "google_secret_manager_secret_version" "google_api_key_version" {
  secret = data.google_secret_manager_secret.google_api_key.id
}
