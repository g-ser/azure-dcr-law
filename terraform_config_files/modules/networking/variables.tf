variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  nullable    = false
}

variable "location" {
  description = "The location of the vnet to create."
  type        = string
  nullable    = false
}

variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
}

variable "nsg_name" {
  description = "The name of the network security group"
  type        = string
}

variable "vnet_address_space" {
  type        = string
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

# If no values specified, this defaults to Azure DNS
variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "subnet_name" {
  description = "A name of the subnet inside the vNet."
  type        = string
  default     = "subnet1"
}

variable "subnet_address_space" {
  description = "The address space that is used by the subnet"
  default     = "10.0.1.0/24"
  type        = string
}

variable "nic_name" {
  description = "The name of the network interface attached to the server"
  default     = "server-nic"
  type        = string
}

variable "ip_name" {
  description = "The name of the IP of the network interface attached to the server"
  default     = "internal-ip"
  type        = string
}
