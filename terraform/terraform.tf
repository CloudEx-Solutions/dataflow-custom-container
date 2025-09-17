terraform {
  required_version = "~> 1.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = local.gcp_project
  region  = local.gcp_region
}
