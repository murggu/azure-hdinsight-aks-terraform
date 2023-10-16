resource "azapi_resource" "hdi_aks_cluster_flink" {
  type                      = "Microsoft.HDInsight/clusterpools/clusters@2023-06-01-preview"
  name                      = "flink-${local.basename}"
  parent_id                 = azapi_resource.hdi_aks_cluster_pool.id
  location                  = azurerm_resource_group.hdi_rg.location
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      clusterType = "flink",
      computeProfile = {
        nodes = [
          {
            type   = "head",
            vmSize = "Standard_D8ds_v5",
            count  = 2
          },
          {
            type   = "worker",
            vmSize = "Standard_D8ds_v5",
            count  = 3
          }
        ]
      },
      clusterProfile = {
        clusterVersion = "1.0.6",
        ossVersion     = var.flink_version,
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
        flinkProfile = {
          numReplicas = 2,
          jobManager = {
            cpu    = 4,
            memory = 8000
          },
          taskManager = {
            cpu    = 4,
            memory = 4000
          },
          historyServer = {
            cpu    = 1,
            memory = 2000
          },
          storage = {
            storageUri = "abfs://default@${azurerm_storage_account.hdi_st.primary_dfs_host}"
          },
          catalogOptions = {
            hive = {
              metastoreDbConnectionURL            = "jdbc:sqlserver://${azurerm_mssql_server.hdi_sql.name}.database.windows.net;database=${azurerm_mssql_database.hdi_sqldb.name};encrypt=true;trustServerCertificate=true;create=false;loginTimeout=30",
              metastoreDbConnectionUserName       = azurerm_mssql_server.hdi_sql.administrator_login,
              metastoreDbConnectionPasswordSecret = "sqlhdi"
            }
          }
        }
      }
    }
  })
  response_export_values = ["*"]

  count = var.enable_flink_cluster ? 1 : 0

  tags = local.tags
}
