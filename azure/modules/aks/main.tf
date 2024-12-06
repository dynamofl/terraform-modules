# Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "main" {
  count               = var.use_existing ? 0 : 1
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  sku_tier            = "Standard"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                         = var.default_node_pool.name
    vm_size                      = var.default_node_pool.vm_size
    os_disk_size_gb              = var.default_node_pool.os_disk_size_gb
    type                         = "VirtualMachineScaleSets"
    os_disk_type                 = "Ephemeral"
    vnet_subnet_id               = var.default_node_pool.vnet_subnet_id
    zones                        = var.default_node_pool.zones
    auto_scaling_enabled         = var.default_node_pool.auto_scaling_enabled
    min_count                    = var.default_node_pool.min_count
    max_count                    = var.default_node_pool.max_count
    node_public_ip_enabled       = false
    os_sku                       = var.default_node_pool.os_sku
    only_critical_addons_enabled = var.default_node_pool.only_critical_addons_enabled

    upgrade_settings {
      max_surge                     = var.default_node_pool.upgrade_settings.max_surge
      drain_timeout_in_minutes      = var.default_node_pool.upgrade_settings.drain_timeout_in_minutes
      node_soak_duration_in_minutes = var.default_node_pool.upgrade_settings.node_soak_duration_in_minutes
    }
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled       = var.oidc_issuer_enabled
  workload_identity_enabled = var.workload_identity_enabled

  service_mesh_profile {
    mode                             = var.service_mesh_profile.mode
    internal_ingress_gateway_enabled = var.service_mesh_profile.internal_ingress_gateway_enabled
    external_ingress_gateway_enabled = var.service_mesh_profile.external_ingress_gateway_enabled
    revisions                        = var.service_mesh_profile.revisions
  }

  workload_autoscaler_profile {
    keda_enabled = var.workload_autoscaler_profile.keda_enabled
  }

  network_profile {
    network_plugin = var.network_profile.network_plugin
  }
}

# Node Pools
resource "azurerm_kubernetes_cluster_node_pool" "node_pools" {
  for_each               = var.additional_node_pools
  name                   = each.key
  kubernetes_cluster_id  = azurerm_kubernetes_cluster.main[0].id
  vm_size                = each.value.vm_size
  os_disk_size_gb        = each.value.os_disk_size_gb
  os_disk_type           = each.value.os_disk_type
  vnet_subnet_id         = each.value.vnet_subnet_id
  max_pods               = each.value.max_pods
  zones                  = each.value.zones
  node_labels            = each.value.node_labels
  auto_scaling_enabled   = each.value.auto_scaling_enabled
  min_count              = each.value.min_count
  max_count              = each.value.max_count
  node_public_ip_enabled = false
  node_taints            = each.value.node_taints
}
