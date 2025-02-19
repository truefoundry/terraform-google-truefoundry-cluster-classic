terraform {
  required_version = "~> 1.4"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.21"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6.21"
    }
  }
}
