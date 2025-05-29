terraform {
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

resource "google_storage_bucket" "terraform_state" {
  name          = var.bucket_name
  location      = var.bucket_location
  storage_class = var.storage_class
  force_destroy = var.force_destroy

  versioning {
    enabled = var.enable_versioning
  }

  uniform_bucket_level_access = var.uniform_bucket_level_access

  # Prevenir eliminación accidental en producción
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      condition {
        age = lifecycle_rule.value.age
      }
      action {
        type = lifecycle_rule.value.action
      }
    }
  }

  # Configuración opcional para prevenir destrucción
  lifecycle {
    prevent_destroy = true
  }

  labels = var.labels
}
