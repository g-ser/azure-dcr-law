# Motivation

The purpose of this repo is to experiment with Azure monitoring. In particular, it explores the new way of setting up monitoring in Azure using Data Collection Rules together with the new agent of Azure called AMA (Azure Monitor Agent). In order to set up monitoring the resources listed below are provisioned by the terraform configuration files included in [terraform_config_files](/terraform_config_files/). It was chosen to use terraform modules so the relevant resources are organized within modules as follows:
* Terraform Module: monitoring
    * Azure Resources:
        * Log Analytics Workspace
        * Data collection rule
        * Data collection rule association
        * Action Group
        * Heartbeat Alert Rule
        * Available Memory Alert Rule
        * Available Disk Space Alert Rule
* Terraform Module: networking
    * Azure Resources:
        * Virtual Network (VNet)
        * Network Security Group
        * VNet subnet 
        * Network Interface
* Terraform Module: server
    * Azure Resources:
        * Windows Virtual Machine
        * User Assigned Managed Identity
        * Azure Monitor Windows Agent extension

# Description of the set up

A Windows VM is created attached to a NIC which resides in a VNet. In addition, a log analytics workspace is created and a Data Collection Rule (DCR) which gathers performance metrics (i.e. available disk space & available memory) from the Windows VM which (thanks to the DCR) is associated to the log analytics workspace. In other words, the DCR binds together the Windows VM and the log analytics workspace. The metrics from the VM are sent to the log analytics workspace through the AMA (Azure Monitoring Agent) which is installed on the windows VM as an extension. Three alert rules are created (i.e. for heartbeat, disk space and memory) targeting the log analytics workspace. Moreover, an action group is created which sends notification to an e-mail address. Once the alert rule is triggered, the action group is invoked and the e-mail is sent to the recipient. 


# Authenticating to Azure:

Given Hashicorp's suggestion regarding authenticating to Azure when running Terraform locally ([Authenticating using the Azure CLI](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)), it was chosen to follow the approach of using the Azure CLI for authentication. 

Login to the Azure CLI using: ```az login```

List the subscriptions where you have access: ```az account list```

Specify the Subscription to use: ```az account set --subscription="SUBSCRIPTION_ID"```

# Modify the values of the variables

The variables used by the terraform scripts of this repo, get their values from the file [terraform.tfvars](terraform_config_files/terraform.tfvars). You can modify the assigned values but keep in mind the naming rules imposed by Azure ([Naming rules and restrictions for Azure resources](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)). Don't neglect to provide a valid email address (name of variable is action_group_email_address), so you get email notifications when an alert is fired. 
# Run terraform

All the commands listed below, must run within the following folder: [terraform_config_files](/terraform_config_files/)

First initialize the working directory: ```terraform init```

Create an execution plan to preview the changes: ```terraform plan```

Execute the actions included in the action plan generated before: ```terraform apply```