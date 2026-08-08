terraform {
  required_version = ">= 1.6.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "= 3.0.2"
    }
  }

  backend "s3" {
      bucket = "terraform-state"
      key    = "prod/terraform.tfstate"
      region = "eu-central-1"

      skip_credentials_validation = true
      skip_metadata_api_check     = true
      skip_region_validation      = true
      skip_requesting_account_id  = true
      use_path_style              = true
    }
}

provider "docker" {}