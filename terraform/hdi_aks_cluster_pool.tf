resource "azapi_resource" "hdi_aks_cluster_pool" {
  type                      = "Microsoft.HDInsight/clusterpools@2023-06-01-preview"
  name                      = "hdi-pool-${local.basename}"
  parent_id                 = azurerm_resource_group.hdi_rg.id
  location                  = azurerm_resource_group.hdi_rg.location
  schema_validation_enabled = false

  body = jsonencode({
    properties = {
      networkProfile = {
        subnetId = azurerm_subnet.hdi_snet_default.id
      },
      logAnalyticsProfile = {
        enabled     = true,
        workspaceId = azurerm_log_analytics_workspace.hdi_log.id
      },
      clusterPoolProfile = {
        clusterPoolVersion = var.pool_version
      },
      computeProfile = {
        vmSize = var.pool_node_vm_size
      }
    }
  })
  response_export_values = ["*"]
}

# Assign Managed Identity Operator role for the agent pool's identity on User Managed Identity

resource "azurerm_role_assignment" "hdi_id_role_pool" {
  scope                = azurerm_user_assigned_identity.hdi_id.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = jsondecode(azapi_resource.hdi_aks_cluster_pool.output).properties.aksClusterProfile.aksClusterAgentPoolIdentityProfile.msiObjectId

  depends_on = [
    azapi_resource.hdi_aks_cluster_pool,
    azurerm_user_assigned_identity.hdi_id
  ]
}