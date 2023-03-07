resource "google_secret_manager_secret" "client_secret" {
  secret_id = "NOTIFY_CLIENT_SECRET"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "client_secret_version" {
  secret = google_secret_manager_secret.client_secret.id
  secret_data = local.client_secret
}
