terraform {
  required_version = ">= 1.4"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.82.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "4.81.0"
    }
  }
}