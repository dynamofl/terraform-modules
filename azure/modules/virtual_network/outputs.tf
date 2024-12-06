output "vnet_id" {
  value = var.use_existing_vnet ? data.azurerm_virtual_network.existing[0].id : azurerm_virtual_network.vnet[0].id
}

output "vnet_name" {
  value = var.use_existing_vnet ? data.azurerm_virtual_network.existing[0].name : azurerm_virtual_network.vnet[0].name
}

output "subnet_ids" {
  value = var.use_existing_vnet ? {
    for k, v in data.azurerm_subnet.existing_subnets :
    k => v.id
    } : {
    for k, v in azurerm_subnet.subnets :
    k => v.id
  }
}
