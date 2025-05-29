# Variables para Azure AKS
variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

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
  default     = 1
}

variable "vm_size" {
  description = "The size of the virtual machines to use for the AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
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
  default     = 1
}

variable "node_pool_max_count" {
  description = "Maximum number of nodes for auto-scaling"
  type        = number
  default     = 3
}

variable "enable_azure_monitor_for_containers" {
  description = "Enable Azure Monitor for containers"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "The resource ID of the Log Analytics Workspace"
  type        = string
  default     = null
}

# Variables para Azure Authentication
variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID"
  type        = string
}


# Variables para GCP
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}
