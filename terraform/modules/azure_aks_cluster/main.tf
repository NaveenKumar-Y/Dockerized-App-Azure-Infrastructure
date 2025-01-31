resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = "1.21.2"

  default_node_pool {
    name       = "default-nodepool"
    node_count = var.node_count
    vm_size    = var.vm_size
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  private_cluster {
    enabled = true
  }
}


resource "kubernetes_deployment" "container_deployment" {
  metadata {
    name      = "app-container-deployment"
    namespace = "default"
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app-container"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-container"
        }
      }
      spec {
        container {
          name  = "app-container"
          image = "naveenykumar/simpletimeservice:latest"  
          ports {
            container_port = 18630
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "container_service" {
  metadata {
    name      = "app-container-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "app-container"
    }
    ports {
      port        = 18630
      target_port = 18630
      protocol    = "TCP"
    }
    type = "LoadBalancer"  
    load_balancer_backend_address_pool_id = var.bcp_id
  }
}


