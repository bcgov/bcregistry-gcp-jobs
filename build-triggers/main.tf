terraform {
  cloud {
    organization = "BCRegistry"
    workspaces {
      name = "gcp-build-triggers-dev"
    }
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
