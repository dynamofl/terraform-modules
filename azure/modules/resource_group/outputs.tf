output "name" {
  value = var.use_existing ? var.existing_resource_group_name : azurerm_resource_group.this[0].name
}