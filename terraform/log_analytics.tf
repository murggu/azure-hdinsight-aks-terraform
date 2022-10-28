resource "azurerm_log_analytics_workspace" "hdi_log" {
  name                = "log-${local.basename}"
  location            = azurerm_resource_group.hdi_rg.location
  resource_group_name = azurerm_resource_group.hdi_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.tags
}