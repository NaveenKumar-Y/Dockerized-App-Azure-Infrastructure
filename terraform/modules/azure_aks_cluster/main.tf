terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.0"
    }
  }
}


resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  node_resource_group = var.aks_node_resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "devnodepool"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin = "azure"       # assigns Pod IPs from the same subnet as AKS nodes
    service_cidr   = "10.1.0.0/16" # cluster IPs
    dns_service_ip = "10.1.0.10"   # internal dns server
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
    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
    }
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
    # load_balancer_backend_address_pool_id = var.bcp_id
    # load_balancer_ip = var.load_balancer_ip
  }
}

data "kubectl_file_documents" "aks_services" {
  content = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
}

data "kubectl_path_documents" "internal_lb_service" {
  pattern = "k8s/aks_internal_lb.yaml"
}

# data "kubectl_service" "app_container_service" {
#   metadata {
#     name      = "app-container-service"
#     namespace = "default"
#   }
# }

# resource "kubectl_manifest" "internal_lb" {
#   for_each  = data.kubectl_file_documents.aks_services.manifests
#   yaml_body = each.value
# }

resource "kubectl_manifest" "internal_lb" {
  for_each  = data.kubectl_file_documents.aks_services.manifests
  yaml_body = each.value

  # Using a local-exec provisioner to run kubectl command to fetch the LoadBalancer IP
  provisioner "local-exec" {
    command = "kubectl get svc app-container-service -n default -o=jsonpath='{.status.loadBalancer.ingress[0].ip}'"
    # Capture output of the kubectl command
    interpreter = ["bash", "-c"]
  }
}





