resource "azurerm_resource_group" "hdi_rg" {
  name     = "rg-${local.basename}"
  location = var.location

  tags = local.tags
}
