resource "azapi_resource" "hdi_hilo_cluster_flink" {
  type                      = "Microsoft.HDInsight/clusterpools/clusters@2021-09-15-preview"
  name                      = "flink-${local.basename}"
  parent_id                 = azapi_resource.hdi_hilo_cluster_pool.id
  location                  = azurerm_resource_group.hdi_rg.location
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      clusterType = "flink",
      computeProfile = {
        # vmSize = "Standard_D14_v2",
        # count  = 5
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
        stackVersion = var.flink_version,
        identityProfile = {
          msiResourceId = azurerm_user_assigned_identity.hdi_id.id,
          msiClientId   = azurerm_user_assigned_identity.hdi_id.client_id,
          msiObjectId   = azurerm_user_assigned_identity.hdi_id.principal_id
        },
        authorizationProfile = {
          userIds = [data.azurerm_client_config.current.object_id]
        },
        secretsProfile         = null,
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
            storageUri = "abfs://default@${azurerm_storage_account.hdi_st.name}.dfs.core.windows.net"
          }
        }
      }
    }
  })
  response_export_values = ["*"]

  count = var.enable_flink_cluster ? 1 : 0

  tags = local.tags
}
