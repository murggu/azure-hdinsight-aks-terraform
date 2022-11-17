resource "azapi_resource" "hdi_hilo_cluster_trino" {
  type                      = "Microsoft.HDInsight/clusterpools/clusters@2021-09-15-preview"
  name                      = "trino-${local.basename}"
  parent_id                 = azapi_resource.hdi_hilo_cluster_pool.id
  location                  = azurerm_resource_group.hdi_rg.location
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      clusterType = "trino",
      computeProfile = {
        vmSize = "Standard_D8as_v4",
        count  = 5
      },
      clusterProfile = {
        stackVersion = "0.381.0-0.1",
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
              type               = "secret",
              keyVaultObjectName = "sqlhdi"
            }
          ]
        },
        serviceConfigsProfiles = [
          {
            serviceName = "trino",
            configs = [
              {
                component = "catalogs",
                files = [
                  {
                    fileName = "catalog-hive-trino-01.properties",
                    values = {
                      "connector.name" = "hive"
                      "hive.allow-drop-table" = "true"
                    }
                  }
                ]
              }
            ]
          }
        ],
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
        trinoProfile = {
          catalogOptions = {
            hive = [
              {
                catalogName                   = "catalog-hive-trino-01",
                metastoreDbConnectionURL      = "jdbc:sqlserver://${azurerm_mssql_server.hdi_sql.name}.database.windows.net;database=${azurerm_mssql_database.hdi_sqldb.name};encrypt=true;trustServerCertificate=true;create=false;loginTimeout=30",
                metastoreDbConnectionUserName = azurerm_mssql_server.hdi_sql.administrator_login,
                metastoreDbConnectionPassword = "$${SECRET_REF:'sqlhdi'}",
                metastoreWarehouseDir         = "abfs://default@${azurerm_storage_account.hdi_st.name}.dfs.core.windows.net/hive/warehouse"
              }
            ]
          }
        }
      }
    }
  })
  response_export_values = ["*"]

  count = var.enable_trino_cluster ? 1 : 0

  tags = local.tags
}