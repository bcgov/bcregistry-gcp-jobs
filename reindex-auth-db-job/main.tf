terraform {
  cloud {
    organization = "BCRegistry"
    workspaces {
      name = "reindex-auth-db-job-dev"
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
