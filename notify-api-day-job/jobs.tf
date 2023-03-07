resource "google_cloud_run_v2_job" "test_gcp_job" {
  name     = var.notify_api_job.name
  location = var.region
  launch_stage = "BETA"

  template {
    template {
      containers {
        image = "${var.region}-docker.pkg.dev/${var.environment.project_id}/${var.notify_api_job.registry_repo}/${var.notify_api_job.image}:${var.notify_api_job.tag}"
# TODO USE 1Password
        env {
          name = "NOTIFY_CLIENT"
          value = local.client
        }
        env {
          name = "NOTIFY_CLIENT_SECRET"
          value = local.secret
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
