# AKS Outputs
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks_stage.aks_cluster_id
}

output "aks_host" {
  description = "AKS cluster endpoint"
  value       = module.aks_stage.host
  sensitive   = true
}

output "aks_client_certificate" {
  description = "AKS client certificate"
  value       = module.aks_stage.client_certificate
  sensitive   = true
}

output "aks_client_key" {
  description = "AKS client key"
  value       = module.aks_stage.client_key
  sensitive   = true
}

output "aks_cluster_ca_certificate" {
  description = "AKS cluster CA certificate"
  value       = module.aks_stage.cluster_ca_certificate
  sensitive   = true
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.stage.name
}
