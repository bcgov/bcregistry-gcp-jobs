data "google_artifact_registry_repository" "job_repo" {
    repository_id = var.registry_repo
    location = var.region
}

resource "google_cloudbuild_trigger" "trigger" {

  for_each   = {
    for index, job in var.jobs:
    job.name => job
  }

  name        = each.value.trigger
  location = var.region

  trigger_template {
    branch_name = var.github.github_branch
    repo_name   = "github_${var.github.github_owner}_${var.github.github_repository}"
  }

  substitutions = {
    _LOCATION = var.region
    _REGISTRY_REPO = var.registry_repo
    _TAG = "dev"
    _IMAGE = "${each.value.trigger}-image"
  }

  filename = "cloudbuild.yaml"
  included_files = ["${each.value.trigger}/**"]
}
