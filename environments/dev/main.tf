terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "certain-perigee-459722-b4-tfstate"
    prefix = "terraform/environments/dev"
  }

  required_version = ">= 1.0"
}

# Providers configuration
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "kubernetes" {
  host                   = module.aks_dev.host
  client_certificate     = base64decode(module.aks_dev.client_certificate)
  client_key             = base64decode(module.aks_dev.client_key)
  cluster_ca_certificate = base64decode(module.aks_dev.cluster_ca_certificate)
}

# Azure Resource Group for Development
resource "azurerm_resource_group" "dev" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# AKS Cluster for Development
module "aks_dev" {
  source = "../../modules/aks"

  cluster_name                        = var.cluster_name
  location                            = azurerm_resource_group.dev.location
  resource_group_name                 = azurerm_resource_group.dev.name
  dns_prefix                          = var.dns_prefix
  node_count                          = var.node_count
  vm_size                             = var.vm_size
  tags                                = var.tags
  kubernetes_version                  = var.kubernetes_version
  node_os_disk_size_gb                = var.node_os_disk_size_gb
  enable_node_pool_auto_scaling       = var.enable_node_pool_auto_scaling
  node_pool_min_count                 = var.node_pool_min_count
  node_pool_max_count                 = var.node_pool_max_count
  enable_azure_monitor_for_containers = var.enable_azure_monitor_for_containers
  log_analytics_workspace_id          = var.log_analytics_workspace_id
}

# Kubernetes Namespaces for Development
resource "kubernetes_namespace" "microservices" {
  metadata {
    name = "microservices"
    labels = {
      environment = "dev"
      purpose     = "ecommerce-app"
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      environment = "dev"
      purpose     = "observability"
    }
  }
}
