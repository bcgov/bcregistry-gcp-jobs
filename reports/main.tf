# terraform {
#   cloud {
#     organization = "BCRegistry"
#     workspaces {
#       name = "reports-job-dev"
#     }
#   }
# }

terraform {
  backend "gcs" {
    bucket = "common-tools-terraform-state"
    prefix = "jobs/reports-prod"
  }
}

terraform {
  required_providers {
    google = ">= 3.3"
    onepassword = {
      source = "1Password/onepassword"
      version = "1.1.4"
    }
  }

}

provider "google" {
  project = var.environment.project_id
}
