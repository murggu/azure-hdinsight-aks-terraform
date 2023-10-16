resource "azapi_resource" "hdi_aks_cluster_spark" {
  type                      = "Microsoft.HDInsight/clusterpools/clusters@2023-06-01-preview"
  name                      = "spark-${local.basename}"
  parent_id                 = azapi_resource.hdi_aks_cluster_pool.id
  location                  = azurerm_resource_group.hdi_rg.location
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      clusterType = "spark",
      computeProfile = {
        nodes = [
          {
            type   = "head",
            vmSize = "Standard_D8ads_v5",
            count  = 3
          },
          {
            type   = "worker",
            vmSize = "Standard_D8ads_v5",
            count  = 2
          }
        ]
      },
      clusterProfile = {
        clusterVersion = "1.0.6",
        ossVersion     = var.spark_version,
        identityProfile = {
          msiResourceId = azurerm_user_assigned_identity.hdi_id.id,
          msiClientId   = azurerm_user_assigned_identity.hdi_id.client_id,
          msiObjectId   = azurerm_user_assigned_identity.hdi_id.principal_id
        },
        authorizationProfile = {
          userIds = [data.azurerm_client_config.current.object_id]
        },
        secretsProfile = {
          keyVaultResourceId = azurerm_key_vault.hdi_kv.id,
          secrets = [
            {
              referenceName      = "sqlhdi",
              type               = "Secret",
              keyVaultObjectName = "sqlhdi"
            }
          ]
        },
        serviceConfigsProfiles = [],
        logAnalyticsProfile = {
          enabled = true,
          applicationLogs = {
            stdErrorEnabled = true,
            stdOutEnabled   = true
          },
          metricsEnabled = true
        },
        sshProfile = {
          count     = 1,
          podPrefix = "pod"
        },
        sparkProfile = {
          defaultStorageUrl = "abfs://default@${azurerm_storage_account.hdi_st.name}.dfs.core.windows.net/",
          metastoreSpec = {
            dbServerHost         = "${azurerm_mssql_server.hdi_sql.name}.database.windows.net",
            dbName               = azurerm_mssql_database.hdi_sqldb.name,
            dbUserName           = azurerm_mssql_server.hdi_sql.administrator_login,
            dbPasswordSecretName = "sqlhdi",
            keyVaultId           = azurerm_key_vault.hdi_kv.id
          }
        }
      }
    }
  })
  response_export_values = ["*"]

  count = var.enable_spark_cluster ? 1 : 0

  tags = local.tags
}