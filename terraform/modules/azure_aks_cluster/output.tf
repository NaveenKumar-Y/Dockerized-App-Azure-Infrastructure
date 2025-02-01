output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config
}


# output "internal_lb_ip" {
#   value = kubectl_manifest.internal_lb["default/app-container-service"].attributes["status.loadBalancer.ingress[0].ip"]
# }

# output "internal_lb_ip" {
#   value = data.kubectl_service.app_container_service.status[0].load_balancer.ingress[0].ip
# }

output "internal_lb_ip" {
  value = "kubectl get svc app-container-service -n default -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'"
}