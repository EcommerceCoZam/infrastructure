variable "cluster_name" {
  type        = string
  description = "The name of the AKS cluster."
}

variable "location" {
  type        = string
  description = "The Azure region where the AKS cluster will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the AKS cluster will be deployed."
}

variable "dns_prefix" {
  type        = string
  description = "The DNS prefix for the AKS cluster."
}

variable "node_count" {
  type        = number
  description = "The initial number of nodes for the AKS cluster."
  default     = 1
}

variable "vm_size" {
  type        = string
  description = "The size of the virtual machines to use for the AKS nodes."
  default     = "Standard_DS2_v2"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}

variable "kubernetes_version" {
  type        = string
  description = "The version of Kubernetes to use for the AKS cluster. It is recommended to use an LTS version."
  default     = "1.29"
}

variable "node_os_disk_size_gb" {
  type        = number
  description = "The size of the OS disk for each node in GB."
  default     = 128
}

variable "enable_node_pool_auto_scaling" {
  type        = bool
  description = "Enable auto-scaling for the default node pool."
  default     = true
}

variable "node_pool_min_count" {
  type        = number
  description = "Minimum number of nodes for auto-scaling in the default node pool."
  default     = 1
}

variable "node_pool_max_count" {
  type        = number
  description = "Maximum number of nodes for auto-scaling in the default node pool."
  default     = 3
}

variable "enable_azure_monitor_for_containers" {
  type        = bool
  description = "Enable Azure Monitor for containers (OMS Agent)."
  default     = true
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "The resource ID of the Log Analytics Workspace to use for Azure Monitor for containers. Required if enable_azure_monitor_for_containers is true."
  default     = null # User must provide this if enabling monitoring
}
