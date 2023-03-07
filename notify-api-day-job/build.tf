# gcp github repo needs to be created (i.e. seeded) see:
# https://source.cloud.google.com/repo/connect
# cloud build triggers then show up here: https://console.cloud.google.com/cloud-build/triggers

data "google_artifact_registry_repository" "job_repo" {
    repository_id = "sre-repo"
    location = var.region
}

resource "google_cloudbuild_trigger" "notify-api-job-trigger" {
  name        = "notify-api-job"
  location = var.region

  trigger_template {
    branch_name = "main"
    repo_name   = "github_${var.github_owner}_${var.notify_api_job.github_repository}"
  }

  substitutions = {
    _LOCATION = var.region
    _REGISTRY_REPO = var.notify_api_job.registry_repo
    _TAG = var.notify_api_job.tag
    _IMAGE = var.notify_api_job.image
  }

  filename = "cloudbuild.yaml"
  included_files = ["${var.notify_api_job.subdir}/"]
}
