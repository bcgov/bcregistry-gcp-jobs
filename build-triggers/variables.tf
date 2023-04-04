variable "environment" {
  type = object({
    project_id     = string
  })
  description = "GCP project parameters"

  default = {
    project_id      = "c4hnrd-dev"
  }
}


variable "jobs" {
  type = list(object({
    trigger                = string
  }))
  description = "Builds for jobs"

  default = [
    {
      trigger    = "notify-api-day-job"
    },
    {
      trigger    = "reindex-db-job"
    },
    {
      trigger    = "notebooks"
    },
    {
      trigger    = "reports"
    }
  ]
}

variable "github" {
  type = object({
    github_repository      = string
    github_owner           = string
    github_branch          = string
  })
  default = {
    github_repository = "bcregistry-gcp-jobs"
    github_owner = "bcgov"
    github_branch = "main"
  }
}

variable "registry_repo" {
    default = "job-repo"
}

variable "region" {
    default = "northamerica-northeast1"
}
