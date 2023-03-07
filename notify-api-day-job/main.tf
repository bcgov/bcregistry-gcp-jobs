# add image builder
# set up repository watcher
# https://cloud.google.com/build/docs/automate-builds
terraform {
  cloud {
    organization = "BCRegistry"
    workspaces {
      name = "gcp-notify-api-job-dev"
    }
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
