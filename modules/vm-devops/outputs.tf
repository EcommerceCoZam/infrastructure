output "vm_instance_id" {
  description = "ID of the VM instance"
  value       = google_compute_instance.devops_vm.id
}

output "vm_instance_name" {
  description = "Name of the VM instance"
  value       = google_compute_instance.devops_vm.name
}

output "external_ip" {
  description = "External IP address of the VM"
  value       = var.enable_external_ip ? (var.reserve_static_ip ? google_compute_address.devops_static_ip[0].address : google_compute_instance.devops_vm.network_interface[0].access_config[0].nat_ip) : null
}

output "static_ip_reserved" {
  description = "Whether a static IP was reserved"
  value       = var.reserve_static_ip
}

output "internal_ip" {
  description = "Internal IP address of the VM"
  value       = google_compute_instance.devops_vm.network_interface[0].network_ip
}

output "ssh_connections" {
  description = "SSH connection commands for all users"
  value = var.enable_external_ip ? {
    for user_key, user_data in var.ssh_users :
    user_key => "ssh ${user_data.username}@${google_compute_instance.devops_vm.network_interface[0].access_config[0].nat_ip}"
  } : null
}

output "devops_services_urls" {
  description = "URLs for DevOps services"
  value = var.enable_external_ip ? {
    jenkins    = "http://${google_compute_instance.devops_vm.network_interface[0].access_config[0].nat_ip}:8080"
    sonarqube  = "http://${google_compute_instance.devops_vm.network_interface[0].access_config[0].nat_ip}:9000"
    grafana    = "http://${google_compute_instance.devops_vm.network_interface[0].access_config[0].nat_ip}:3000"
    prometheus = "http://${google_compute_instance.devops_vm.network_interface[0].access_config[0].nat_ip}:9090"
    argocd     = "http://${google_compute_instance.devops_vm.network_interface[0].access_config[0].nat_ip}:8090"
  } : null
}

output "zone" {
  description = "Zone of the VM"
  value       = google_compute_instance.devops_vm.zone
}

output "machine_type" {
  description = "Machine type of the VM"
  value       = google_compute_instance.devops_vm.machine_type
}
