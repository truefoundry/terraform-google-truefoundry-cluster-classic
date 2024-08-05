terraform {
  required_version = ">= 1.8"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.39.1"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.39.1"
    }
  }
}