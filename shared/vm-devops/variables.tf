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

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-east1-b"
}

# VM Configuration
variable "vm_name" {
  description = "Name of the DevOps VM"
  type        = string
  default     = "ecommerce-devops-vm"
}

variable "machine_type" {
  description = "Machine type for the DevOps VM"
  type        = string
  default     = "e2-standard-4"
}

variable "boot_disk_size" {
  description = "Boot disk size for the DevOps VM in GB"
  type        = number
  default     = 100
}

# Network Configuration
variable "network_name" {
  description = "Name of the DevOps network"
  type        = string
  default     = "devops-network"
}

variable "subnetwork_name" {
  description = "Name of the DevOps subnetwork"
  type        = string
  default     = "devops-subnetwork"
}

variable "subnetwork_cidr" {
  description = "CIDR range for the DevOps subnetwork"
  type        = string
  default     = "10.0.0.0/24"
}

variable "create_network" {
  description = "Whether to create a new network for DevOps"
  type        = bool
  default     = true
}

variable "enable_external_ip" {
  description = "Enable external IP for the DevOps VM"
  type        = bool
  default     = true
}

variable "reserve_static_ip" {
  description = "Reserve a static IP for the DevOps VM"
  type        = bool
  default     = true
}

# SSH Configuration
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
  default     = ["0.0.0.0/0"]
}

variable "source_ip_ranges" {
  description = "Source IP ranges allowed for DevOps services"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_ports" {
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

variable "labels" {
  description = "Labels to apply to the DevOps VM"
  type        = map(string)
  default = {
    purpose     = "devops-tools"
    environment = "shared"
    managed-by  = "terraform"
  }
}
