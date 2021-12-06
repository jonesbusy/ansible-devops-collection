terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "= 2.15.0"
    }
  }
  required_version = ">= 1.0.11"
  backend "s3" {

  }
}
