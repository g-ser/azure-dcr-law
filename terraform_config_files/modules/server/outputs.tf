output "vm_resource_identifier" {
  description = "the resource identifier of the VM"
  value       = azurerm_windows_virtual_machine.windows_vm.id
}