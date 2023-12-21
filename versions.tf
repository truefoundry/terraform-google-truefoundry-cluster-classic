terraform {
  required_version = ">= 1.4"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.10.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.10.0"
    }
  }
}