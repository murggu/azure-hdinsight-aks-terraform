resource "azurerm_key_vault" "hdi_kv" {
  name                = "kv-${local.basename}"
  location            = azurerm_resource_group.hdi_rg.location
  resource_group_name = azurerm_resource_group.hdi_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "Backup",
      "Delete",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set"
    ]
  }

  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "hdi_kv_access_policy" {
  key_vault_id = azurerm_key_vault.hdi_kv.id
  tenant_id    = azurerm_user_assigned_identity.hdi_id.tenant_id
  object_id    = azurerm_user_assigned_identity.hdi_id.principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_key_vault_secret" "hdi_kv_sqldb_secret" {
  name         = "sqlhdi"
  value        = azurerm_mssql_server.hdi_sql.administrator_login_password
  key_vault_id = azurerm_key_vault.hdi_kv.id
}