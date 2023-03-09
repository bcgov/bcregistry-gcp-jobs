resource "google_cloud_run_v2_job" "job" {
  name     = var.job.name
  location = var.region
  launch_stage = "BETA"

  template {
    template {
      containers {
        image = "${var.region}-docker.pkg.dev/c4hnrd-dev/${var.job.registry_repo}/${var.job.image}:${var.job.tag}"
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

resource "google_cloud_scheduler_job" "scheduler" {
  name             = var.job.name
  schedule         = "0 0 * * *"
  time_zone        = "America/Vancouver"
  attempt_deadline = "320s"
  region = var.region
  retry_config {
    retry_count = 1
  }
  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.environment.project_id}/jobs/${var.job.name}:run"
    oauth_token {
      service_account_email = "${var.environment.sa}@${var.environment.project_id}.iam.gserviceaccount.com"
      scope = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}
