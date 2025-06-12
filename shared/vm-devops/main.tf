terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "certain-perigee-459722-b4-tfstate"
    prefix = "terraform/shared/vm-devops"
  }

  required_version = ">= 1.0"
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# VM DevOps usando el módulo
module "devops_vm" {
  source = "../../modules/vm-devops"

  project_id         = var.gcp_project_id
  vm_name            = var.vm_name
  machine_type       = var.machine_type
  zone               = var.zone
  region             = var.gcp_region
  boot_disk_size     = var.boot_disk_size
  network_name       = var.network_name
  subnetwork_name    = var.subnetwork_name
  subnetwork_cidr    = var.subnetwork_cidr
  create_network     = var.create_network
  enable_external_ip = var.enable_external_ip
  reserve_static_ip  = var.reserve_static_ip
  ssh_users          = var.ssh_users
  ssh_source_ranges  = var.ssh_source_ranges
  source_ip_ranges   = var.source_ip_ranges
  allowed_ports      = var.allowed_ports
  labels             = var.labels
}
