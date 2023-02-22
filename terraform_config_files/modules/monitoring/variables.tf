variable "vm_id" {
  description = "The resource ID of the VM which will be targeted by the data collection rule"
  type        = string
}

variable "dcr_name" {
  description = "Name of the data collection rule"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
  nullable    = false
}

variable "log_analytics_workspace_name" {
  description = "The name of the log analytics workspace"
  type        = string
}

variable "location" {
  description = "The location of the vnet to create."
  type        = string
  nullable    = false
}

variable "action_group_email_name" {
  type        = string
  description = "The name associated to the e-mail address"
}

variable "action_group_email_address" {
  type        = string
  description = "The email address to which alerts will be sent"
}

variable "vm_name" {
  description = "The nane of the vm"
  type        = string
}

