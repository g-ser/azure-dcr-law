output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_subnet_id" {
  description = "The id of subnets created inside the newly created vNet"
  value       = azurerm_subnet.vnet_subnet.id
}

output "nic_id" {
  description = "The id of the NIC created inside the subnet which belongs to the VNET"
  value       = azurerm_network_interface.nic.id
}

