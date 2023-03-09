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
    trigger                = string
    github_repository      = string
    github_owner           = string
    github_branch          = string
    registry_repo          = string
    tag                    = string
  })
  description = "Notify API resend job"

  default = {
    name       = "reindex-auth-db-job"
    trigger    = "reindex-db-job"
    registry_repo = "sre-repo"
    github_repository = "bcregistry-gcp-jobs"
    github_owner = "bcgov"
    github_branch = "main"
    tag        = "dev"
  }
}

variable "region" {
    default = "us-west2"
}

variable "db_connection" {
  type = object({
    host = string
    port = string
    db_user = string
    oc_server = string
    })
  description = "oc port forwarded db connection"
  default = {
    host = "localhost"
    port = "8006"
    db_user="postgres"
    oc_server="https://api.silver.devops.gov.bc.ca:6443"
  }
}
