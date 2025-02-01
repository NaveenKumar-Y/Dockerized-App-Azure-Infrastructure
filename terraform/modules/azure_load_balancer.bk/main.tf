
# resource "azurerm_public_ip" "lb_public_ip" {
#   name                = "loadbalancer-public-ip"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
#   sku                 = "Standard" 
# }

resource "azurerm_lb" "load_balancer" {
  name                = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  frontend_ip_configuration {
    name = "loadbalancer-fip"
    # public_ip_address_id = azurerm_public_ip.lb_public_ip.id 
    subnet_id = var.public_subnet_id
  }
}

# resource "azurerm_lb_backend_address_pool" "lb_backend" {
#   loadbalancer_id = azurerm_lb.load_balancer.id
#   name            = "LbBackendPool"
# }

resource "azurerm_lb_backend_address_pool" "lb_backend" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = "LbBackendPool"

  backend_ip_configurations = [var.load_balancer_ip]
}


resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.load_balancer.id
  name                           = "http-rule"
  protocol                       = "Tcp"
  frontend_port                  = 18630
  backend_port                   = 18630
  frontend_ip_configuration_name = "loadbalancer-fip"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.lb_backend.id]
}


# resource "azurerm_lb_backend_address_pool" "backend_pool" {
#   name = "backend-pool"
#   #   resource_group_name = var.resource_group_name
#   loadbalancer_id = azurerm_lb.load_balancer.id
#   #   allocation_method   = "Static"
# }



###
# resource "azurerm_lb" "lb" {
#   name                = "aks-loadbalancer"
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   frontend_ip_configuration {
#     name                 = "loadbalancer-ip"
#     public_ip_id         = azurerm_public_ip.lb_public_ip.id
#   }
# }

# resource "azurerm_public_ip" "lb_public_ip" {
#   name                = "loadbalancer-public-ip"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   allocation_method   = "Static"
# }
