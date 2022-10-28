resource "azurerm_mssql_server" "hdi_sql" {
  name                         = "sql-${local.basename}"
  resource_group_name          = azurerm_resource_group.hdi_rg.name
  location                     = azurerm_resource_group.hdi_rg.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"

  tags = local.tags
}

resource "azurerm_mssql_database" "hdi_sqldb" {
  name      = "sqldb${local.safe_prefix}${local.safe_postfix}"
  server_id = azurerm_mssql_server.hdi_sql.id
  collation = "SQL_Latin1_General_CP1_CI_AS"

  tags = local.tags
}