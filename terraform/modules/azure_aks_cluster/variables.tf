variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "The location of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
}

variable "vm_size" {
  description = "VM size for the AKS nodes"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to associate with the AKS cluster"
  type        = string
}

# variable "bcp_id" {}

variable "load_balancer_ip" {
    description = " LoadBalancer will get created with the IP specified in this field"
}

variable "kubernetes_version" {
    default = "1.21.2"
}