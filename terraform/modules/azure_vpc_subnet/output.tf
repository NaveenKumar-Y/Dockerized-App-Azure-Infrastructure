output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "public_subnet_1_id" {
  description = "ID of the public subnet 1"
  value       = azurerm_subnet.public_subnet_1.id
}

output "private_subnet_1_id" {
  description = "ID of the private subnet 1"
  value       = azurerm_subnet.private_subnet_1.id
}
