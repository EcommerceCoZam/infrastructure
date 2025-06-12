# DevOps VM Outputs
output "vm_instance_id" {
  description = "ID of the DevOps VM instance"
  value       = module.devops_vm.vm_instance_id
}

output "vm_instance_name" {
  description = "Name of the DevOps VM instance"
  value       = module.devops_vm.vm_instance_name
}

output "external_ip" {
  description = "External IP address of the DevOps VM"
  value       = module.devops_vm.external_ip
}

output "internal_ip" {
  description = "Internal IP address of the DevOps VM"
  value       = module.devops_vm.internal_ip
}

output "static_ip_reserved" {
  description = "Whether a static IP was reserved"
  value       = module.devops_vm.static_ip_reserved
}

output "ssh_connections" {
  description = "SSH connection commands for all users"
  value       = module.devops_vm.ssh_connections
}

output "devops_services_urls" {
  description = "URLs for DevOps services"
  value       = module.devops_vm.devops_services_urls
}

output "zone" {
  description = "Zone of the DevOps VM"
  value       = module.devops_vm.zone
}

output "machine_type" {
  description = "Machine type of the DevOps VM"
  value       = module.devops_vm.machine_type
}
