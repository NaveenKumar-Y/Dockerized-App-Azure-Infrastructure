variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "location" {
  description = "The location of the load balancer"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "public_subnet_id" {
  description = "public subnet id"
}

variable "load_balancer_ip" {}