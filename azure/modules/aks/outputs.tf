output "id" {
  value = azurerm_kubernetes_cluster.main[0].id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.main[0].kube_config[0]
  sensitive = true
}

output "node_pools" {
  value = azurerm_kubernetes_cluster_node_pool.node_pools
}
