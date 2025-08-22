terraform {
  required_version = "~> 1.4"
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "6.47" #6.48 bug - https://github.com/issues/created?issue=hashicorp%7Cterraform-provider-google%7C24069
    }
    google = {
      source  = "hashicorp/google"
      version = "6.47"
    }
  }
}
