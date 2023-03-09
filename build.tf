data "google_artifact_registry_repository" "job_repo" {
    repository_id = "sre-repo"
    location = var.region
}

resource "google_cloudbuild_trigger" "trigger" {
  name        = var.job.trigger
  location = var.region

  trigger_template {
    branch_name = var.job.github_branch
    repo_name   = "github_${var.job.github_owner}_${var.job.github_repository}"
  }

  substitutions = {
    _LOCATION = var.region
    _REGISTRY_REPO = var.job.registry_repo
    _TAG = "dev"
    _IMAGE = var.job.image
  }

  filename = "cloudbuild.yaml"
  included_files = ["${var.job.subdir}/**"]
}
