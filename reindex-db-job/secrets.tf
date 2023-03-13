resource "google_secret_manager_secret" "oc_token" {
  for_each     = local.pass_values
  secret_id = "OC_TOKEN_${each.value.oc_namespace}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "oc_token_version" {
  for_each     = local.pass_values
  secret = google_secret_manager_secret.oc_token[each.key].id
  secret_data = each.value.oc_token
}

resource "google_secret_manager_secret" "oc_svc" {
  for_each     = local.pass_values
  secret_id = "DB_SVC_NAME_${each.value.oc_namespace}"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "oc_svc_version" {
  for_each     = local.pass_values
  secret = google_secret_manager_secret.oc_svc[each.key].id
  secret_data = each.value.oc_svc
}
