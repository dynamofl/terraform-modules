
resource "azurerm_postgresql_flexible_server" "this" {
  count                       = var.use_existing ? 0 : 1
  name                        = var.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  version                     = var.version
  sku_name                    = var.sku_name
  storage_mb                  = var.storage_mb
  administrator_login         = var.administrator_login
  administrator_password      = var.administrator_login_password

  delegated_subnet_id         = var.vnet_subnet_id

  backup_retention_days       = var.backup_retention_days
  zone                        = var.zone
  tags                        = var.tags
}

# Create databases if PostgreSQL Flexible Server is being created
resource "azurerm_postgresql_flexible_database" "databases" {
  count                       = var.use_existing ? 0 : length(var.databases)
  name                        = var.databases[count.index]
  resource_group_name         = var.resource_group_name
  server_name                 = azurerm_postgresql_flexible_server.this[0].name
  collation                   = var.database_collation
  charset                     = var.database_charset
}

# Output the PostgreSQL Flexible Server connection details if using an existing server
data "azurerm_postgresql_flexible_server" "existing" {
  count = var.use_existing ? 1 : 0
  name  = var.existing_server_name
  resource_group_name = var.resource_group_name
}

# Output connection strings
locals {
  connection_strings = var.use_existing ? {
    postgres = format("postgres://%s:%s@%s/%s", var.administrator_login, var.administrator_login_password, data.azurerm_postgresql_flexible_server.existing[0].fqdn, var.name)
  } : {
    postgres = format("postgres://%s:%s@%s/%s", var.administrator_login, var.administrator_login_password, azurerm_postgresql_flexible_server.this[0].fqdn, var.name)
  }
}
