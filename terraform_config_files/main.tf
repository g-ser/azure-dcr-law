# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.44.1"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

module "networking" {
  source               = "./modules/networking"
  resource_group_name  = azurerm_resource_group.this.name
  location             = var.location
  vnet_name            = var.vnet_name
  nsg_name             = var.nsg_name
  vnet_address_space   = var.vnet_address_space
  dns_servers          = var.dns_servers
  subnet_name          = var.subnet_name
  subnet_address_space = var.subnet_address_space
  nic_name             = var.nic_name
  ip_name              = var.ip_name
}

module "server" {
  source                  = "./modules/server"
  vm_name                 = var.vm_name
  vm_size                 = var.vm_size
  vm_admin_password       = var.vm_admin_password
  vm_admin_username       = var.vm_admin_username
  vm_image_sku            = var.vm_image_sku
  vm_image_version        = var.vm_image_version
  vm_network_interface_id = module.networking.nic_id
  resource_group_name     = azurerm_resource_group.this.name
  location                = var.location
}

module "monitoring" {
  source                       = "./modules/monitoring"
  vm_id                        = module.server.vm_resource_identifier
  dcr_name                     = var.dcr_name
  resource_group_name          = azurerm_resource_group.this.name
  log_analytics_workspace_name = var.log_analytics_workspace_name
  location                     = var.location
  action_group_email_address   = var.action_group_email_address
  action_group_email_name      = var.action_group_email_name
  vm_name                      = var.vm_name
}
