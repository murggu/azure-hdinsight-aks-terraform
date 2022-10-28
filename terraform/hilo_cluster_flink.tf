resource "azurerm_resource_group_template_deployment" "hdi_hilo_cluster_flink" {
  name                = "hilo-flink-${local.basename}"
  resource_group_name = azurerm_resource_group.hdi_rg.name
  deployment_mode     = "Incremental"
  template_content    = file("../arm/hilo_cluster_flink.json")

  parameters_content = jsonencode({

    clusterName                   = { value = "flink-${local.basename}" }
    clusterPoolName               = { value = azurerm_resource_group_template_deployment.hdi_hilo_cluster_pool.name }
    location                      = { value = azurerm_resource_group.hdi_rg.location }
    clusterType                   = { value = "flink" }
    workerNodeVMSize              = { value = "Standard_D8as_v4" }
    workerNodeCount               = { value = "5" }
    clusterVersion                = { value = "1.13.1-0.3" }
    currentUserObjectId           = { value = data.azurerm_client_config.current.object_id }
    msiResourceId                 = { value = azurerm_user_assigned_identity.hdi_id.id }
    msiClientId                   = { value = azurerm_user_assigned_identity.hdi_id.client_id }
    msiObjectId                   = { value = azurerm_user_assigned_identity.hdi_id.principal_id }
    isLogAnalyticsEnabled         = { value = true }
    isLogAnalyticsStdErrorEnabled = { value = true }
    isLogAnalyticsStdOutEnabled   = { value = true }
    isLogAnalyticsMetricsEnabled  = { value = true }
    # hiveDBPasswordKeyVaultId      = { value = azurerm_key_vault.hdi_kv.id }
    # hiveDBPasswordSecretName      = { value = "sqlhdi" }
    storageAccountEndpoint  = { value = "${azurerm_storage_account.hdi_st.name}.dfs.core.windows.net" }
    storageAccountContainer = { value = "default" }
    # hiveCatalogName               = { value = "catalog-hive-flink-01" }
    # hiveDatabaseServer            = { value = azurerm_mssql_server.hdi_sql.name }
    # hiveDatabaseName              = { value = azurerm_mssql_database.hdi_sqldb.name }
    # hiveDatabaseUserName          = { value = azurerm_mssql_server.hdi_sql.administrator_login }
    secureShellNodeCount    = { value = "1" }
    secureShellPodPrefix    = { value = "pod" }
    taskManagerCount        = { value = "2" }
    taskManagerCPU          = { value = "2" }
    taskManagerMemoryInMB   = { value = "2000" }
    jobManagerCPU           = { value = "1" }
    jobManagerMemoryInMB    = { value = "2000" }
    historyServerCPU        = { value = "1" }
    historyServerMemoryInMB = { value = "2000" }
  })

  depends_on = [
    azurerm_role_assignment.hdi_id_role_pool,
    azurerm_role_assignment.hdi_st_role_identity,
    azurerm_key_vault_secret.hdi_kv_sqldb_secret
  ]

  count = var.enable_flink_cluster ? 1 : 0

  tags = local.tags
}