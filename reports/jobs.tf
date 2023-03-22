resource "google_cloud_run_v2_job" "job" {
  for_each   = {
    for index, job in var.jobs:
      job.name => job
  }
  name = each.value.name
  location = var.region
  launch_stage = "BETA"

  template {
    template {
      containers {
        image = "${var.region}-docker.pkg.dev/c4hnrd-dev/${var.registry_repo}/${each.value.trigger}-image:${var.environment.tag}"
        env {
          name = "DB_HOST"
          value = var.db_connection.host
        }
        env {
          name = "DB_PORT"
          value = var.db_connection.port
        }
        env {
          name = "DB_NAME"
          value = local.pass_values[each.key].db_name
        }
        env {
          name = "DB_USER"
          value = var.db_connection.db_user
        }
        env {
          name = "OC_SERVER"
          value = var.db_connection.oc_server
        }
        env {
          name = "OC_NAMESPACE"
          value = local.pass_values[each.key].oc_namespace
        }
        env {
          name = "OC_TOKEN"
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret_version.oc_token_version[each.key].secret
              version = "1"
            }
          }
        }
        env {
          name = "DB_SVC_NAME"
          value_source {
            secret_key_ref {
              secret = google_secret_manager_secret_version.oc_svc_version[each.key].secret
              version = "1"
            }
          }
        }
      }
    }
  }
}

resource "google_cloud_scheduler_job" "scheduler" {
  for_each   = {
    for index, job in var.jobs:
    job.name => job
  }
  name             = each.value.name
  schedule         = "0 1 * * 0"
  time_zone        = "America/Vancouver"
  attempt_deadline = "320s"
  region           = var.region
  retry_config {
    retry_count = 1
  }
  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.environment.project_id}/jobs/${each.value.name}:run"
    oauth_token {
      service_account_email = "${var.environment.sa}@${var.environment.project_id}.iam.gserviceaccount.com"
      scope = "https://www.googleapis.com/auth/cloud-platform"
    }
  }
}
