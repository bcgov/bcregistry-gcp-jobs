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
    image                  = string
    github_repository      = string
    github_owner           = string
    github_branch          = string
    subdir                 = string
    registry_repo          = string
    tag                    = string
  })
  description = "Notify API resend job"

  default = {
    name       = "notify-api-day-job"
    image      = "notify-api-day-job-image"
    registry_repo = "sre-repo"
    github_repository = "bcregistry-gcp-jobs"
    github_owner = "bcgov"
    github_branch = "main"
    subdir     = "notify-api-day-job"
    tag        = "dev"
  }
}

variable "region" {
    default = "us-west2"
}
