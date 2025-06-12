variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "certain-perigee-459722-b4"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "location" {
  description = "Artifact Registry location"
  type        = string
  default     = "us-central1"
}

variable "repository_name" {
  description = "Name of the Artifact Registry repository"
  type        = string
  default     = "ecommerce-microservices"
}

variable "labels" {
  description = "Labels for the registry"
  type        = map(string)
  default = {
    purpose     = "microservices-registry"
    environment = "multi-env"
    project     = "ecommerce-cozam"
    managed-by  = "terraform"
  }
}

variable "cicd_service_accounts" {
  description = "Service accounts for CI/CD pipelines"
  type        = list(string)
  default     = []
}

variable "enable_aks_access" {
  description = "Enable AKS access to the registry"
  type        = bool
  default     = false
}

variable "aks_service_account" {
  description = "Service account for AKS cluster access"
  type        = string
  default     = ""
}
