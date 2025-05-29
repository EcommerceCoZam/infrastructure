variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "certain-perigee-459722-b4"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "The name of the GCS bucket for Terraform state"
  type        = string
  default     = "certain-perigee-459722-b4-tfstate"
}

variable "bucket_location" {
  description = "The location of the GCS bucket"
  type        = string
  default     = "US"
  validation {
    condition = contains([
      "US", "EU", "ASIA",
      "us-central1", "us-east1", "us-west1", "us-west2",
      "europe-west1", "europe-west2", "europe-west3",
      "asia-east1", "asia-southeast1"
    ], var.bucket_location)
    error_message = "Bucket location must be a valid GCS location."
  }
}

variable "storage_class" {
  description = "The storage class of the bucket"
  type        = string
  default     = "STANDARD"
  validation {
    condition = contains([
      "STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"
    ], var.storage_class)
    error_message = "Storage class must be one of: STANDARD, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "enable_versioning" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "uniform_bucket_level_access" {
  description = "Enable uniform bucket-level access"
  type        = bool
  default     = true
}

variable "force_destroy" {
  description = "Allow deletion of bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "prevent_destroy" {
  description = "Prevent accidental deletion of the bucket"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to apply to the bucket"
  type        = map(string)
  default = {
    purpose     = "terraform-state"
    environment = "infrastructure"
    managed-by  = "terraform"
  }
}

variable "lifecycle_rules" {
  description = "Lifecycle rules for the bucket"
  type = list(object({
    age    = number
    action = string
  }))
  default = [
    {
      age    = 30
      action = "Delete"
    }
  ]
}
