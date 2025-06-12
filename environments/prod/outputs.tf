# DevOps VM Outputs
output "devops_vm_name" {
  description = "Name of the DevOps VM"
  value       = module.devops_vm.vm_instance_name
}

output "devops_vm_external_ip" {
  description = "External IP of the DevOps VM"
  value       = module.devops_vm.external_ip
}

output "devops_vm_internal_ip" {
  description = "Internal IP of the DevOps VM"
  value       = module.devops_vm.internal_ip
}

output "ssh_connections" {
  description = "SSH connection commands"
  value       = module.devops_vm.ssh_connections
}

output "devops_services_urls" {
  description = "URLs for DevOps services"
  value       = module.devops_vm.devops_services_urls
}
