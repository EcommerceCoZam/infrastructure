resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                        = "default"
    node_count                  = var.enable_node_pool_auto_scaling ? null : var.node_count
    vm_size                     = var.vm_size
    os_disk_size_gb             = var.node_os_disk_size_gb
    enable_auto_scaling         = var.enable_node_pool_auto_scaling
    min_count                   = var.enable_node_pool_auto_scaling ? var.node_pool_min_count : null
    max_count                   = var.enable_node_pool_auto_scaling ? var.node_pool_max_count : null
    temporary_name_for_rotation = "tempnodepool"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}
