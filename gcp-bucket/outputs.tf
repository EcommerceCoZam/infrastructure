output "bucket_name" {
  description = "The name of the created GCS bucket"
  value       = google_storage_bucket.terraform_state.name
}

output "bucket_url" {
  description = "The URL of the created GCS bucket"
  value       = google_storage_bucket.terraform_state.url
}

output "bucket_self_link" {
  description = "The self link of the created GCS bucket"
  value       = google_storage_bucket.terraform_state.self_link
}

output "project_id" {
  description = "The GCP project ID"
  value       = var.project_id
}

output "backend_config" {
  description = "Backend configuration for using this bucket in other Terraform configs"
  value = {
    bucket = google_storage_bucket.terraform_state.name
    prefix = "terraform/state"
  }
}
