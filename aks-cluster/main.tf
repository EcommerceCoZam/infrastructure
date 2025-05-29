resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

module "aks" {
  source                              = "./modules/aks"
  cluster_name                        = var.cluster_name
  location                            = azurerm_resource_group.main.location
  resource_group_name                 = azurerm_resource_group.main.name
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

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_namespace" "stage" {
  metadata {
    name = "stage"
  }
}

resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}

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
    prefix = "terraform/state"
  }
}
