resource "azurerm_virtual_network" "hdi_vnet" {
  name                = "vnet-${local.basename}"
  location            = azurerm_resource_group.hdi_rg.location
  resource_group_name = azurerm_resource_group.hdi_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = local.tags
}

resource "azurerm_subnet" "hdi_snet_default" {
  name                                          = "vnet-${local.basename}-default"
  resource_group_name                           = azurerm_resource_group.hdi_rg.name
  virtual_network_name                          = azurerm_virtual_network.hdi_vnet.name
  address_prefixes                              = ["10.0.0.0/24"]
  service_endpoints                             = ["Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.Storage"]
  private_endpoint_network_policies_enabled     = false
  private_link_service_network_policies_enabled = false
}

resource "azurerm_network_security_group" "hdi_nsg" {
  name                = "nsg-${local.basename}"
  location            = azurerm_resource_group.hdi_rg.location
  resource_group_name = azurerm_resource_group.hdi_rg.name

  security_rule {
    name                       = "ssh_ip"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.http.ip.body
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "hdi_nsg_snet_association" {
  subnet_id                 = azurerm_subnet.hdi_snet_default.id
  network_security_group_id = azurerm_network_security_group.hdi_nsg.id
}