output "registry_url" {
  description = "URL of the Artifact Registry"
  value       = "${google_artifact_registry_repository.microservices.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.microservices.repository_id}"
}

output "registry_name" {
  description = "Name of the Artifact Registry repository"
  value       = google_artifact_registry_repository.microservices.name
}

output "registry_location" {
  description = "Location of the Artifact Registry"
  value       = google_artifact_registry_repository.microservices.location
}

output "docker_config" {
  description = "Docker configuration for CI/CD pipelines"
  value = {
    registry_url = "${google_artifact_registry_repository.microservices.location}-docker.pkg.dev"
    project_id   = var.project_id
    repository   = google_artifact_registry_repository.microservices.repository_id
    full_url     = "${google_artifact_registry_repository.microservices.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.microservices.repository_id}"
  }
}
