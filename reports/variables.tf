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

data "google_project" "project_info" {
  project_id = var.environment.project_id
}

variable "region" {
    default = "northamerica-northeast1"
}

variable "data_dir" {
  default = "/opt/app-root/data/"
}

variable "registry_repo" {
    default = "job-repo"
}

variable "db_connection_ocp" {
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

variable "jobs" {
  type = list(object({
    name                   = string
    trigger                = string
    vault_section          = optional(string)
    cron                   = string
    custom_vars            = optional(list(string), [])
  }))

  description = "OpenShift database reindexing jobs"

  default = [
   {
     name = "worksafe-job"
     trigger = "worksafe-notebook"
     cron = "0 10 * * *"
     vault_section = "entity-db2"
   },
   {
     name = "dyedurham-job"
     trigger = "dyedurham-notebook"
     cron = "0 8 1 * *"
     vault_section = "entity-db2"
   },
   {
     name = "bn-failure-batch-job"
     trigger = "bn-failure-batch-notebook"
     cron = "00 11 * * *"
     vault_section = "entity-db2"
   },
   {
     name = "phishing-scan-job"
     trigger = "phishing-scan-notebook"
     cron = "0 4 * * *"
     custom_vars = ["GOOGLE_API_KEY", "BING_API_KEY", "BING_ID", "VIRUS_TOTAL_API_KEY"]
   },
   {
     name = "ar-prompt-filing-job"
     trigger = "ar-prompt-filing-notebook"
     cron = "00 06 * * *"
     vault_section = "entity-db2"
   },
   {
     name = "bn-processing-batch-job"
     trigger = "bn-processing-batch-notebook"
     cron = "00 06 * * *"
     vault_section = "entity-db2"
   },
  ]
}
