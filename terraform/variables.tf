variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}


variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}

variable "public_subnet_1_prefixes" {
  description = "Address prefixes for the public subnet"
  type        = list(string)
}

variable "private_subnet_1_prefixes" {
  description = "Address prefixes for the private subnet"
  type        = list(string)
}

variable "public_subnet_2_prefixes" {
  description = "Address prefixes for the public subnet"
  type        = list(string)
}

variable "private_subnet_2_prefixes" {
  description = "Address prefixes for the private subnet"
  type        = list(string)
}

variable "public_subnet_1_name" {
  description = "Name of the public subnet"
  type        = string
}

variable "public_subnet_2_name" {
  description = "Name of the public subnet"
  type        = string
}

variable "private_subnet_1_name" {
  description = "Name of the private subnet"
  type        = string
}

variable "private_subnet_2_name" {
  description = "Name of the private subnet"
  type        = string
}

variable "private_subnet_service_endpoints" {
  description = "Service endpoints for the private subnet"
  type        = list(string)
}

##

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
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

variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
}

# variable "public_subnet_id" {
#   description = "public subnet"
# }

variable "kubernetes_version" {
}

variable "aks_node_resource_group_name" {}