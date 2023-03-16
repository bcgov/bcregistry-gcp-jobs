variable "environment" {
  type = object({
    project_id     = string
    sa             = string
  })
  description = "GCP project parameters"

  default = {
    project_id      = "c4hnrd-dev"
    sa              = "terraform-sa"
  }
}

variable "job" {
  type = object({
    name                   = string
    github_repository      = string
    github_owner           = string
    github_branch          = string
    trigger                = string
    registry_repo          = string
    tag                    = string
  })
  description = "Notify API resend job"

  default = {
    name       = "notify-api-day-job"
    trigger    = "notify-api-day-job"
    registry_repo = "job-repo"
    github_repository = "bcregistry-gcp-jobs"
    github_owner = "bcgov"
    github_branch = "main"
    tag        = "dev"
  }
}

variable "region" {
    default = "northamerica-northeast1"
}
