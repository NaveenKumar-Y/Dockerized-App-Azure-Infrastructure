# create vnet
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

#create subnets
resource "azurerm_subnet" "public_subnet_1" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = var.public_subnet_1_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.public_subnet_1_prefixes
}

resource "azurerm_subnet" "private_subnet_1" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = var.private_subnet_1_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.private_subnet_1_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet" "public_subnet_2" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = var.public_subnet_2_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.public_subnet_2_prefixes
}

resource "azurerm_subnet" "private_subnet_2" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = var.private_subnet_2_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.private_subnet_2_prefixes
  service_endpoints    = ["Microsoft.Storage"]
}

# Create a Public Route Table (For Public Subnets)
resource "azurerm_route_table" "public_rt" {
  name                = "public-route-table"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_route" "internet_route" {
  name                = "public-default-route"
  resource_group_name = var.resource_group_name
  route_table_name    = azurerm_route_table.public_rt.name
  address_prefix      = "0.0.0.0/0"
  next_hop_type       = "Internet"
}

resource "azurerm_subnet_route_table_association" "public_subnet_assoc_1" {
  subnet_id      = azurerm_subnet.public_subnet_1.id
  route_table_id = azurerm_route_table.public_rt.id
}

resource "azurerm_subnet_route_table_association" "public_subnet_assoc_2" {
  subnet_id      = azurerm_subnet.public_subnet_2.id
  route_table_id = azurerm_route_table.public_rt.id
}