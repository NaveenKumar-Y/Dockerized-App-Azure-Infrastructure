terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0" # Ensure to specify a valid version
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {
  }
}

provider "kubernetes" {
  host                   = module.aks_cluster.kube_config[0].host
  client_certificate     = base64decode(module.aks_cluster.kube_config[0].client_certificate)
  client_key             = base64decode(module.aks_cluster.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(module.aks_cluster.kube_config[0].cluster_ca_certificate)
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "vpc_subnet" {
  depends_on                       = [azurerm_resource_group.rg]
  source                           = "./modules/azure_vpc_subnet"
  vnet_name                        = var.vnet_name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  address_space                    = var.address_space
  public_subnet_1_name             = var.public_subnet_1_name
  public_subnet_2_name             = var.public_subnet_2_name
  private_subnet_1_name            = var.private_subnet_1_name
  private_subnet_2_name            = var.private_subnet_2_name
  public_subnet_1_prefixes         = var.public_subnet_1_prefixes
  public_subnet_2_prefixes         = var.public_subnet_2_prefixes
  private_subnet_1_prefixes        = var.private_subnet_1_prefixes
  private_subnet_2_prefixes        = var.private_subnet_2_prefixes
  private_subnet_service_endpoints = var.private_subnet_service_endpoints
}

module "aks_cluster" {
  depends_on          = [azurerm_resource_group.rg]
  source              = "./modules/azure_aks_cluster"
  aks_cluster_name    = var.aks_cluster_name
  aks_node_resource_group_name = var.aks_node_resource_group_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kubernetes_version  = var.kubernetes_version
  dns_prefix          = var.dns_prefix
  node_count          = var.node_count
  vm_size             = var.vm_size
  subnet_id           = module.vpc_subnet.private_subnet_1_id
  #   bcp_id              = module.load_balancer.bcp_id
}


module "load_balancer" {
  depends_on          = [azurerm_resource_group.rg]
  source              = "./modules/azure_load_balancer"
  load_balancer_name  = var.load_balancer_name
  location            = var.location
  resource_group_name = var.resource_group_name
  # public_ip_id        = module.load_balancer
  public_subnet_id = module.vpc_subnet.public_subnet_1_id
  load_balancer_ip = module.aks_cluster.internal_lb_ip
}