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

variable "region" {
    default = "northamerica-northeast1"
}

variable "data_dir" {
  default = "/opt/app-root/data/"
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

variable "jobs" {
  type = list(object({
    name                   = string
    trigger                = string
    vault_section          = optional(string, "notify-db2")
    cron                   = string
  }))

  description = "OpenShift database reindexing jobs"

  default = [
   {
     name = "phishing-scan-job"
     trigger = "phishing-scan-notebook"
     cron = "0 5 * * *"
   },
   {
     name = "ar-prompt-filing-job"
     trigger = "ar-prompt-filing-notebook"
     cron = "00 14 * * *"
     vault_section = "entity-db2"
   },
   {
     name = "gc-notify-failures-job"
     trigger = "gc-notify-failures-notebook"
     cron = "0 1 * * *"
     vault_section = "notify-db2"
   },
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
  ]
}

