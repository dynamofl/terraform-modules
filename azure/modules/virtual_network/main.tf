# Conditional VNet Creation
resource "azurerm_virtual_network" "vnet" {
  count               = var.use_existing_vnet ? 0 : 1
  name                = var.vnet_name
  location            = var.location
  address_space       = var.address_space
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Data Source for Existing VNet
data "azurerm_virtual_network" "existing" {
  count               = var.use_existing_vnet ? 1 : 0
  name                = var.existing_vnet_name
  resource_group_name = var.resource_group_name
}

# Conditional Subnet Creation
resource "azurerm_subnet" "subnets" {
  for_each             = var.use_existing_vnet ? {} : var.subnets
  name                 = each.value.name
  address_prefixes     = each.value.address_prefixes
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[0].name
  service_endpoints    = each.value.service_endpoints
  # Delegation block for services
  delegation {
    name = each.value.delegation.name
    service_delegation {
      name    = each.value.delegation.service_name
      actions = each.value.delegation.actions
    }
  }
}

data "azurerm_subnet" "existing_subnets" {
  for_each = var.use_existing_vnet ? toset(var.existing_subnet_names) : toset([])
  name                 = each.value
  virtual_network_name = data.azurerm_virtual_network.existing[0].name
  resource_group_name  = var.resource_group_name
}

