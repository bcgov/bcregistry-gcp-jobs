# terraform {
#   cloud {
#     organization = "BCRegistry"
#     workspaces {
#       name = "gcp-build-triggers-dev"
#     }
#   }
# }

terraform {
  backend "gcs" {
    bucket = "common-tools-terraform-state"
    prefix = "jobs/build-triggers"
  }
}

terraform {
  required_providers {
    google = ">= 3.3"
  }
}

provider "google" {
  project = var.environment.project_id
}
