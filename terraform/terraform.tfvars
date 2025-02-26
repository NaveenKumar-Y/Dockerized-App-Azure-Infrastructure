location            = "East US"
resource_group_name = "naveen-resource-group"
vnet_name           = "naveen-vnet"

public_subnet_1_name  = "public-subnet-1"
public_subnet_2_name  = "public-subnet-2"
private_subnet_1_name = "private-subnet-1"
private_subnet_2_name = "private-subnet-2"

address_space             = ["10.0.0.0/16"]
public_subnet_1_prefixes  = ["10.0.1.0/24"]
public_subnet_2_prefixes  = ["10.0.3.0/24"]
private_subnet_1_prefixes = ["10.0.2.0/24"]
private_subnet_2_prefixes = ["10.0.4.0/24"]

kubernetes_version           = "1.29.11"
aks_cluster_name             = "naveen-aks-cluster"
aks_node_resource_group_name = "aks-resource-group"
dns_prefix                   = "aks-dns"
node_count                   = 1
vm_size                      = "Standard_DS2_v2"



  