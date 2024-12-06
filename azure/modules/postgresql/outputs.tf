output "id" {
  value = var.use_existing ? data.azurerm_postgresql_flexible_server.existing[0].id : azurerm_postgresql_flexible_server.this[0].id
}

output "fqdn" {
  value = var.use_existing ? data.azurerm_postgresql_flexible_server.existing[0].fqdn : azurerm_postgresql_flexible_server.this[0].fqdn
}

output "connection_strings" {
  value = local.connection_strings
}
