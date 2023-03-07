resource "google_cloud_run_v2_job" "notify_api_job" {
  name     = var.notify_api_job.name
  location = var.region
  launch_stage = "BETA"

  template {
    template {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.environment.project_id}/${var.notify_api_job.registry_repo}/${var.notify_api_job.image}:${var.notify_api_job.tag}"
        env {
          name = "NOTIFY_CLIENT"
          value = local.client
        }
        env {
          name = "NOTIFY_CLIENT_SECRET"
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret_version.client_secret_version.secret
              version = "1"
            }
          }
        }
        env {
          name = "KC_URL"
          value = local.kc_url
        }
        env {
          name = "NOTIFY_API_URL"
          value = local.notify_url
        }
      }
    }
  }
}
