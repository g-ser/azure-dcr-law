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

variable "dcr_name" {
  description = "Name of the data collection rule"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "The name of the log analytics workspace"
  type        = string
}

variable "vm_name" {
  description = "The nane of the vm"
  type        = string
}

variable "vm_size" {
  description = "The size of the vm"
  type        = string
}

variable "vm_admin_username" {
  description = "The admin username of the VM"
  type        = string
}

variable "vm_admin_password" {
  description = "The admin password of the VM"
  type        = string
}

variable "vm_image_sku" {
  description = "The sku used for the vm"
  type        = string
}

variable "vm_image_version" {
  description = "The version of the image used to spin up the vm"
  type        = string
}

variable "action_group_email_name" {
  description = "The name associated to the e-mail address of the action group"
  type        = string
}

variable "action_group_email_address" {
  description = "The email address to which alerts will be sent"
  type        = string
}
