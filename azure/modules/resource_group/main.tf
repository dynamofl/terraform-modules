resource "azurerm_resource_group" "this" {
  count    = var.use_existing ? 0 : 1
  name     = var.name
  location = var.location
}
