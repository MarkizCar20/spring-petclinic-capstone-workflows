terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "4.51.0"
    }

  }
  backend "gcs" {
    bucket = "capstone_project_terraform_state"
    prefix = "terraform/state"
  }
}

module "compute" {
  source = "./modules/compute"
}

module "network" {
  source = "./modules/network"

  instance_group = module.compute.compute_instance_group
}