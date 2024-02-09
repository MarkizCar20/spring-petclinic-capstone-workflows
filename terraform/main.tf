terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "4.51.0"
        region = "us-central1"
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

  instace_group_id = module.compute.compute_instance_group_id
}