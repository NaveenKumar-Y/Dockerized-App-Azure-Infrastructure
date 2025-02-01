resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "devnodepool"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.1.0.0/16"
    dns_service_ip = "10.1.0.10"
    # pod_cidr          = "10.2.0.0/16" 
  }

  identity {
    type = "SystemAssigned"
  }

}


resource "kubernetes_deployment" "container_deployment" {
  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
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
          port {
            container_port = 18630
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "container_service" {
  depends_on = [kubernetes_deployment.container_deployment]
  metadata {
    name      = "app-container-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "app-container"
    }
    port {
      port        = 18630
      target_port = 18630
      protocol    = "TCP"
    }
    type = "LoadBalancer"
  }
}


