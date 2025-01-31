output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = azurerm_lb.load_balancer.id
}

# output "bcp_id" {
#   description = "backend address pool id"
#   value       = azurerm_lb_backend_address_pool.backend_pool.id
# }