provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}
