resource "azurerm_user_assigned_identity" "hdi_id" {
  location            = azurerm_resource_group.hdi_rg.location
  name                = "id-${local.basename}"
  resource_group_name = azurerm_resource_group.hdi_rg.name

  tags = local.tags
}