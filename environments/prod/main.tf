terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
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

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
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

# DevOps VM in GCP
module "devops_vm" {
  source = "../../modules/vm-devops"

  project_id         = var.gcp_project_id
  vm_name            = var.devops_vm_name
  machine_type       = var.devops_vm_machine_type
  zone               = var.gcp_zone
  region             = var.gcp_region
  boot_disk_size     = var.devops_vm_disk_size
  network_name       = var.devops_network_name
  subnetwork_name    = var.devops_subnetwork_name
  subnetwork_cidr    = var.devops_subnetwork_cidr
  create_network     = var.create_devops_network
  enable_external_ip = var.enable_devops_external_ip
  reserve_static_ip  = var.reserve_devops_static_ip
  ssh_users          = var.ssh_users
  ssh_source_ranges  = var.ssh_source_ranges
  source_ip_ranges   = var.devops_source_ip_ranges
  allowed_ports      = var.devops_allowed_ports
  labels             = var.devops_vm_labels
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
