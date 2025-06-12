# AKS Outputs
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_dev.aks_cluster_id
}

output "aks_host" {
  description = "AKS cluster endpoint"
  value       = module.aks_dev.host
  sensitive   = true
}

output "aks_client_certificate" {
  description = "AKS client certificate"
  value       = module.aks_dev.client_certificate
  sensitive   = true
}

output "aks_client_key" {
  description = "AKS client key"
  value       = module.aks_dev.client_key
  sensitive   = true
}

output "aks_cluster_ca_certificate" {
  description = "AKS cluster CA certificate"
  value       = module.aks_dev.cluster_ca_certificate
  sensitive   = true
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.dev.name
}
