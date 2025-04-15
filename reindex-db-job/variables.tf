variable "environment" {
  type = object({
    project_id     = string
    sa             = string
    tag            = string
  })
  description = "GCP project parameters"

  default = {
    project_id      = "c4hnrd-dev"
    sa              = "terraform-sa"
    tag             = "dev"
  }
}

variable "jobs" {
  type = list(object({
    name                   = string
    trigger                = string
    vault_section          = string
  }))

  description = "OpenShift database reindexing jobs"

  default = [
    {
      name          = "reindex-pay-db-job"
      trigger       = "reindex-db-job"
      vault_section = "pay-db2"
    },
    {
      name          = "reindex-lear-db-job"
      trigger       = "reindex-db-job"
      vault_section = "entity-db2"
    }
  ]
}

variable "region" {
    default = "northamerica-northeast1"
}

variable "registry_repo" {
    default = "job-repo"
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
