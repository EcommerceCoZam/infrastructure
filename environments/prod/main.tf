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
  }

  backend "gcs" {
    bucket = "certain-perigee-459722-b4-tfstate"
    prefix = "terraform/environments/prod"
  }

  required_version = ">= 1.0"
}

# Providers configuration
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

provider "kubernetes" {
  host                   = module.aks_prod.host
  client_certificate     = base64decode(module.aks_prod.client_certificate)
  client_key             = base64decode(module.aks_prod.client_key)
  cluster_ca_certificate = base64decode(module.aks_prod.cluster_ca_certificate)
}

# Azure Resource Group for Production
resource "azurerm_resource_group" "prod" {
  name     = var.azure_resource_group_name
  location = var.azure_location
  tags     = var.tags
}

# AKS Cluster for Production
module "aks_prod" {
  source = "../../modules/aks"

  cluster_name                        = var.cluster_name
  location                            = azurerm_resource_group.prod.location
  resource_group_name                 = azurerm_resource_group.prod.name
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

# Kubernetes Namespaces for Production
resource "kubernetes_namespace" "microservices" {
  metadata {
    name = "microservices"
    labels = {
      environment = "prod"
      purpose     = "ecommerce-app"
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      environment = "prod"
      purpose     = "observability"
    }
  }
}
