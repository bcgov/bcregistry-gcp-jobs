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
    name                   = string
    trigger                = string
  }))
  description = "Notify API resend job"

  default = [
    { name       = "notify-api-day-job"
      trigger    = "notify-api-day-job"
    },
    { name       = "reindex-auth-db-job"
      trigger    = "reindex-db-job"
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
    default = "sre-repo"
}

variable "region" {
    default = "us-west2"
}
