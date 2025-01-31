variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
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

variable "private_subnet_service_endpoints" {
  description = "Service endpoints for the private subnet"
  type        = list(string)
}
