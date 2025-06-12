# DevOps VM in GCP
module "devops_vm" {
  source = "../../modules/vm-devops"

  project_id         = var.gcp_project_id
  vm_name            = var.devops_vm_name
  machine_type       = var.devops_vm_machine_type
  zone               = var.gcp_zone
  region             = var.gcp_region
  boot_disk_size     = var.devops_vm_disk_size
  network_name       = var.devops_network_name
  subnetwork_name    = var.devops_subnetwork_name
  subnetwork_cidr    = var.devops_subnetwork_cidr
  create_network     = var.create_devops_network
  enable_external_ip = var.enable_devops_external_ip
  reserve_static_ip  = true
  ssh_users          = var.ssh_users
  ssh_source_ranges  = var.ssh_source_ranges
  source_ip_ranges   = var.devops_source_ip_ranges
  allowed_ports      = var.devops_allowed_ports
  labels             = var.devops_vm_labels
}
