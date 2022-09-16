terraform {

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.22.3"
    }
  }

  backend "s3" {
    endpoint                    = "sfo3.digitaloceanspaces.com"
    bucket                      = "ndsq-terraform-state"
    key                         = "infra/terraform.tfstate"
    region                      = "sfo3"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
  }
}

provider "digitalocean" {}
