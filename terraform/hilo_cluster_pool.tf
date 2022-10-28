resource "azurerm_resource_group_template_deployment" "hdi_hilo_cluster_pool" {
  name                = "hilo-pool-${local.basename}"
  resource_group_name = azurerm_resource_group.hdi_rg.name
  deployment_mode     = "Incremental"
  template_content    = file("../arm/hilo_cluster_pool.json")

  parameters_content = jsonencode({

    clusterPoolName         = { value = "hilo-pool-${local.basename}" }
    location                = { value = azurerm_resource_group.hdi_rg.location }
    subnetId                = { value = azurerm_subnet.hdi_snet_default.id }
    logAnalyticsWorkspaceId = { value = azurerm_log_analytics_workspace.hdi_log.id }

  })

  tags = local.tags
}

# Assign Managed Identity Operator role for the agent pool's identity on User Managed Identity
# Note: MRGs name is variable so this can be done after pool creation

resource "azurerm_role_assignment" "hdi_id_role_pool" {
  scope                = azurerm_user_assigned_identity.hdi_id.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = data.azurerm_user_assigned_identity.hdi_id_pool[0].principal_id

  depends_on = [
    azurerm_resource_group_template_deployment.hdi_hilo_cluster_pool,
    azurerm_user_assigned_identity.hdi_id
  ]

  count = var.enable_trino_cluster ? 1 : 0
}

data "azurerm_user_assigned_identity" "hdi_id_pool" {
  name                = "${azurerm_resource_group_template_deployment.hdi_hilo_cluster_pool.name}-agentpool"
  resource_group_name = var.managed_rg_name

  count = var.enable_trino_cluster ? 1 : 0
}