# Azure Variables
variable "azure_subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure tenant ID"
  type        = string
}

variable "azure_resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "azure_location" {
  description = "Azure location"
  type        = string
  default     = "East US"
}

# AKS Variables
variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "node_count" {
  description = "The initial number of nodes for the AKS cluster"
  type        = number
  default     = 3
}

variable "vm_size" {
  description = "The size of the virtual machines to use for the AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use for the AKS cluster"
  type        = string
  default     = "1.29"
}

variable "node_os_disk_size_gb" {
  description = "The size of the OS disk for each node in GB"
  type        = number
  default     = 128
}

variable "enable_node_pool_auto_scaling" {
  description = "Enable auto-scaling for the default node pool"
  type        = bool
  default     = true
}

variable "node_pool_min_count" {
  description = "Minimum number of nodes for auto-scaling"
  type        = number
  default     = 2
}

variable "node_pool_max_count" {
  description = "Maximum number of nodes for auto-scaling"
  type        = number
  default     = 5
}

variable "enable_azure_monitor_for_containers" {
  description = "Enable Azure Monitor for containers"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "The resource ID of the Log Analytics Workspace"
  type        = string
  default     = null
}

# GCP Variables
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-east1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-east1-b"
}

# DevOps VM Variables
variable "devops_vm_name" {
  description = "Name of the DevOps VM"
  type        = string
}

variable "devops_vm_machine_type" {
  description = "Machine type for the DevOps VM"
  type        = string
  default     = "e2-standard-4"
}

variable "devops_vm_disk_size" {
  description = "Boot disk size for the DevOps VM in GB"
  type        = number
  default     = 100
}

variable "devops_network_name" {
  description = "Name of the DevOps network"
  type        = string
  default     = "devops-network"
}

variable "devops_subnetwork_name" {
  description = "Name of the DevOps subnetwork"
  type        = string
  default     = "devops-subnetwork"
}

variable "devops_subnetwork_cidr" {
  description = "CIDR range for the DevOps subnetwork"
  type        = string
  default     = "10.0.0.0/24"
}

variable "create_devops_network" {
  description = "Whether to create a new network for DevOps"
  type        = bool
  default     = true
}

variable "enable_devops_external_ip" {
  description = "Enable external IP for the DevOps VM"
  type        = bool
  default     = true
}

variable "ssh_users" {
  description = "Map of SSH users and their public keys"
  type = map(object({
    username   = string
    public_key = string
  }))
}

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed for SSH"
  type        = list(string)
}

variable "devops_source_ip_ranges" {
  description = "Source IP ranges allowed for DevOps services"
  type        = list(string)
}

variable "devops_allowed_ports" {
  description = "Allowed ports for DevOps services"
  type        = list(string)
  default = [
    "8080", # Jenkins
    "9000", # SonarQube
    "3000", # Grafana
    "9090", # Prometheus
    "8090", # ArgoCD
    "9999"  # Trivy
  ]
}

variable "devops_vm_labels" {
  description = "Labels to apply to the DevOps VM"
  type        = map(string)
  default = {
    purpose     = "devops-tools"
    environment = "prod"
    managed-by  = "terraform"
  }
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default = {
    environment = "prod"
    project     = "ecommerce-gzam"
    managed-by  = "terraform"
  }
}

# Agregar al final de variables.tf
variable "reserve_devops_static_ip" {
  description = "Reserve a static IP for the DevOps VM"
  type        = bool
  default     = true
}
