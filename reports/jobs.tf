# Time Sleep resource to introduce a delay before job creation
resource "time_sleep" "wait_for_image" {
  for_each = {
    for index, job in var.jobs : job.name => job
  }

  create_duration = "300s"
}


resource "google_cloud_run_v2_job" "job" {
  for_each = {
    for index, job in var.jobs : job.name => job
  }

  depends_on = [time_sleep.wait_for_image]

  name               = each.value.name
  location           = var.region
  launch_stage       = "BETA"
  deletion_protection = false

  template {
    template {
      containers {
        image = "${var.region}-docker.pkg.dev/c4hnrd-dev/${var.registry_repo}/${each.value.trigger}-image:${var.environment.tag}"

        # Static environment variables
        env {
          name  = "DATA_DIR"
          value = var.data_dir
        }

        env {
          name  = "KC_URL"
          value = local.kc_url
        }

        env {
          name  = "NOTIFY_API_URL"
          value = local.notify_url
        }

        env {
          name = "GOOGLE_API_KEY"
          value_source {
            secret_key_ref {
              secret  = data.google_secret_manager_secret_version.google_api_key_version.secret
              version = "1"
            }
          }
        }

        env {
          name = "GC_NOTIFY_KEY"
          value_source {
            secret_key_ref {
              secret  = data.google_secret_manager_secret_version.gc_secret_version.secret
              version = "1"
            }
          }
        }

        env {
          name  = "NOTIFY_CLIENT"
          value = local.client
        }

        env {
          name = "NOTIFY_CLIENT_SECRET"
          value_source {
            secret_key_ref {
              secret  = data.google_secret_manager_secret_version.client_secret_version.secret
              version = "1"
            }
          }
        }

        env {
          name = "BING_API_KEY"
          value_source {
            secret_key_ref {
              secret  = data.google_secret_manager_secret_version.bing_api_key_version.secret
              version = "1"
            }
          }
        }

        env {
          name = "BING_ID"
          value_source {
            secret_key_ref {
              secret  = data.google_secret_manager_secret_version.bing_id_secret_version.secret
              version = "1"
            }
          }
        }

        env {
          name = "VIRUS_TOTAL_API_KEY"
          value_source {
            secret_key_ref {
              secret  = data.google_secret_manager_secret_version.virus_total_api_key_version.secret
              version = "1"
            }
          }
        }

        dynamic "env" {
          for_each = try(each.value.vault_section != null && !startswith(each.value.vault_section, "gcp-"), false) ? {
            for key, value in {
              "DB_HOST"      = var.db_connection_ocp.host
              "DB_PORT"      = var.db_connection_ocp.port
              "DB_USER"      = var.db_connection_ocp.db_user
              "OC_SERVER"    = var.db_connection_ocp.oc_server
              "DB_NAME"      = local.pass_values[each.key].db_name
              "OC_NAMESPACE" = local.pass_values[each.key].oc_namespace
              "OC_TOKEN"     = local.pass_values[each.key].oc_token
              "DB_SVC_NAME"  = local.pass_values[each.key].oc_svc
            } : key => value if value != null
          } : {}
          content {
            name = env.key
            value = env.value
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
  schedule         = each.value.cron
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
