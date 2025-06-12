terraform {
  backend "gcs" {
    bucket = "certain-perigee-459722-b4-tfstate"
    prefix = "terraform/registry"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Habilitar API de Artifact Registry
resource "google_project_service" "artifactregistry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"

  disable_on_destroy = false
}

# Artifact Registry para imágenes Docker
resource "google_artifact_registry_repository" "microservices" {
  depends_on = [google_project_service.artifactregistry]

  repository_id = var.repository_name
  location      = var.location
  format        = "DOCKER"
  description   = "Docker registry for EcommerceCoZam microservices"

  labels = var.labels
}

# IAM para permitir push/pull desde CI/CD
resource "google_artifact_registry_repository_iam_member" "cicd_writer" {
  count      = length(var.cicd_service_accounts)
  project    = var.project_id
  location   = google_artifact_registry_repository.microservices.location
  repository = google_artifact_registry_repository.microservices.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${var.cicd_service_accounts[count.index]}"
}

# IAM para permitir pull desde AKS (si necesario)
resource "google_artifact_registry_repository_iam_member" "aks_reader" {
  count      = var.enable_aks_access ? 1 : 0
  project    = var.project_id
  location   = google_artifact_registry_repository.microservices.location
  repository = google_artifact_registry_repository.microservices.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${var.aks_service_account}"
}
