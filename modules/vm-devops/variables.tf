variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "vm_name" {
  description = "Name of the VM instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VM"
  type        = string
  default     = "e2-standard-4" # 4 vCPUs, 16GB RAM
}

variable "zone" {
  description = "Zone where the VM will be created"
  type        = string
}

variable "region" {
  description = "Region where the VM will be created"
  type        = string
}

variable "boot_disk_image" {
  description = "Boot disk image"
  type        = string
  default     = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 50
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-standard"
}

variable "network_name" {
  description = "Name of the network"
  type        = string
  default     = "devops-network"
}

variable "subnetwork_name" {
  description = "Name of the subnetwork"
  type        = string
  default     = "devops-subnetwork"
}

variable "subnetwork_cidr" {
  description = "CIDR range for the subnetwork"
  type        = string
  default     = "10.0.0.0/24"
}

variable "create_network" {
  description = "Whether to create a new network"
  type        = bool
  default     = true
}

variable "enable_external_ip" {
  description = "Enable external IP for the VM"
  type        = bool
  default     = true
}

variable "reserve_static_ip" {
  description = "Reserve a static IP for the VM"
  type        = bool
  default     = true
}

variable "network_tags" {
  description = "Network tags for the VM"
  type        = list(string)
  default     = ["devops-vm"]
}

variable "ssh_users" {
  description = "Map of SSH users and their public keys"
  type = map(object({
    username   = string
    public_key = string
  }))
  default = {}
}

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restringir en producción
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

variable "source_ip_ranges" {
  description = "Source IP ranges allowed for DevOps services"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Restringir en producción
}

variable "startup_script" {
  description = "Startup script for the VM"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y curl wget git
    
    # Instalar Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker devops
    
    # Instalar Docker Compose
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # Instalar kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    
    # Instalar Helm
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    
    # Crear directorio para devops
    mkdir -p /home/devops/devops-stack
    chown devops:devops /home/devops/devops-stack
  EOF
}

variable "service_account_email" {
  description = "Service account email for the VM"
  type        = string
  default     = ""
}

variable "service_account_scopes" {
  description = "Service account scopes for the VM"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append"
  ]
}

variable "labels" {
  description = "Labels to apply to the VM"
  type        = map(string)
  default = {
    purpose     = "devops-tools"
    environment = "infrastructure"
    managed-by  = "terraform"
  }
}
