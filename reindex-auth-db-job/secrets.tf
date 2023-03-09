resource "google_secret_manager_secret" "oc_token" {
  secret_id = "OC_TOKEN"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "oc_token_version" {
  secret = google_secret_manager_secret.oc_token.id
  secret_data = local.oc_token
}

resource "google_secret_manager_secret" "oc_namespace" {
  secret_id = "OC_NAMESPACE"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "oc_namespace_version" {
  secret = google_secret_manager_secret.oc_namespace.id
  secret_data = local.oc_namespace
}

resource "google_secret_manager_secret" "oc_svc" {
  secret_id = "DB_SVC_NAME"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "oc_svc_version" {
  secret = google_secret_manager_secret.oc_svc.id
  secret_data = local.oc_svc
}
