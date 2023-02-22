# Create Log Analytics Workspace

resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = var.dcr_name
  resource_group_name = var.resource_group_name
  location            = var.location

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log_analytics_workspace.id
      name                  = "log-analytics-dst"
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["log-analytics-dst"]
  }

  data_sources {

    # memory metrics can be retrieved running the query below on the log analytics workspace

    # Perf
    # | where ObjectName == "Memory" and CounterName == "% Committed Bytes In Use"

    # space disk metrics can be retrieved running the query below on the log analytics workspace 

    # Perf
    # | where ObjectName == "LogicalDisk" and CounterName == "% Free Space"

    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\Memory\\% Committed Bytes In Use", "\\LogicalDisk(*)\\% Free Space"]
      name                          = "perfcounter"
    }

  }

  kind = "Windows"

}

# associate the data collection rule to the VM

resource "azurerm_monitor_data_collection_rule_association" "dcr_vm_association" {
  name                    = var.dcr_name
  target_resource_id      = var.vm_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
}

resource "azurerm_monitor_action_group" "critical_alerts" {
  name                = "CriticalAlertsAction"
  resource_group_name = var.resource_group_name
  short_name          = "ag-critical"
  enabled             = true

  email_receiver {
    name          = var.action_group_email_name
    email_address = var.action_group_email_address
  }
}

# alert rule for the heartbeat of the VM

resource "azurerm_monitor_metric_alert" "heartbeat" {
  name                 = "heartbeat-metricalert"
  resource_group_name  = var.resource_group_name
  scopes               = [azurerm_log_analytics_workspace.log_analytics_workspace.id]
  description          = "Alert will be trigered when heartbeat count is less than 10 on a Windows VM for the last 15 minutes"
  severity             = 1
  enabled              = true
  auto_mitigate        = true
  target_resource_type = "Microsoft.OperationalInsights/workspaces"
  frequency            = "PT1M"
  window_size          = "PT15M"
  
  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Heartbeat"
    aggregation      = "Total"
    operator         = "LessThan"
    threshold        = 9

    dimension {
      name     = "Computer"
      operator = "Include"
      values   = ["*"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical_alerts.id
  }
}

# alert rule for the memory of the VM

resource "azurerm_monitor_metric_alert" "memory" {
  name                 = "memory-metricalert"
  resource_group_name  = var.resource_group_name
  scopes               = [azurerm_log_analytics_workspace.log_analytics_workspace.id]
  description          = "Alert when available Memory is less than 5% for the last 15 minutes"
  severity             = 1
  enabled              = true
  auto_mitigate        = true
  target_resource_type = "Microsoft.OperationalInsights/workspaces"
  frequency            = "PT1M"
  window_size          = "PT15M"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_% Committed Bytes In Use"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 95

    dimension {
      name     = "Computer"
      operator = "Include"
      values   = ["windows-server"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical_alerts.id
  }
}

# alert rule for the disk space of C: drive of the VM


resource "azurerm_monitor_metric_alert" "disk_space" {
  name                 = "disk-space-metricalert"
  resource_group_name  = var.resource_group_name
  scopes               = [azurerm_log_analytics_workspace.log_analytics_workspace.id]
  description          = "Alert when free disk space is less than 10% for the last 15 minutes"
  severity             = 1
  enabled              = true
  auto_mitigate        = true
  target_resource_type = "Microsoft.OperationalInsights/workspaces"
  frequency            = "PT1M"
  window_size          = "PT15M"

  criteria {
    metric_namespace = "Microsoft.OperationalInsights/workspaces"
    metric_name      = "Average_% Free Space"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 10
    dimension {
      name     = "Computer"
      operator = "Include"
      values   = ["${var.vm_name}"]
    }
    dimension {
      name     = "InstanceName"
      operator = "Include"
      values   = ["C:"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.critical_alerts.id
  }
}

