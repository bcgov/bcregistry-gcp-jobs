data "google_secret_manager_secret" "client_secret" {
  secret_id = "NOTIFY_CLIENT_SECRET"
}

data "google_secret_manager_secret_version" "client_secret_version" {
  secret = data.google_secret_manager_secret.client_secret.id
}

data "google_secret_manager_secret_version" "custom_secrets" {
  for_each = toset(["GOOGLE_API_KEY", "BING_API_KEY", "BING_ID", "VIRUS_TOTAL_API_KEY"])

  secret = format("projects/%s/secrets/%s", data.google_project.project_info.number, each.value)
}
