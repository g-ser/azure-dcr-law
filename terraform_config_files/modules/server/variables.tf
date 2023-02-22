variable "location" {
  description = "The location of the user assigned managed identity"
  type        = string
  nullable    = false
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  nullable    = false
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
  nullable    = false
}

variable "vm_size" {
  description = "Size of virtual machine"
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

variable "vm_network_interface_id" {
  description = "The resource identifier of the nic to which the VM needs to be attached"
  type        = string
}


