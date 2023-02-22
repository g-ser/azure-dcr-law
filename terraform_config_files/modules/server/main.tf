# create user assigned managed identity

resource "azurerm_user_assigned_identity" "this" {
  location            = var.location
  name                = "ID_test"
  resource_group_name = var.resource_group_name
}

# create windows server

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password

  network_interface_ids = [
    var.vm_network_interface_id
  ]
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this.id]
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
}


# install AMA (Azure Monitoring Agent) extension on the VM 

resource "azurerm_virtual_machine_extension" "AzureMonitorWinAgent" {
  name                       = "AzureMonitorWindowsAgent"
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorWindowsAgent"
  type_handler_version       = 1.9
  auto_upgrade_minor_version = true
  automatic_upgrade_enabled  = true

  virtual_machine_id = azurerm_windows_virtual_machine.windows_vm.id

  settings = <<SETTINGS
  {
    "authentication": 
    {
        "managedIdentity":
            {
                "identifier-name":"mi_res_id",
                "identifier-value":"${azurerm_user_assigned_identity.this.id}"
            }
                }
  }
  SETTINGS
}