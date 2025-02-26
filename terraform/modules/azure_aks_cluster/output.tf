output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config
}
