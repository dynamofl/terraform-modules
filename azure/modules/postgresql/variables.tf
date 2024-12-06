variable "name" {
  description = "Name of the PostgreSQL Flexible Server"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the PostgreSQL server"
  type        = string
}

variable "version" {
  description = "PostgreSQL version (e.g., 13, 14)"
  type        = string
  default     = "14"
}

variable "sku_name" {
  description = "SKU for PostgreSQL Flexible Server"
  type        = string
  default     = "Standard_D4ds_v5"
}

variable "storage_mb" {
  description = "Storage size in MB for the server"
  type        = number
  default     = 128000
}

variable "administrator_login" {
  description = "Administrator username for the PostgreSQL server"
  type        = string
}

variable "administrator_login_password" {
  description = "Administrator password for the PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "vnet_subnet_id" {
  description = "Subnet ID for the PostgreSQL server"
  type        = string
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = false
}

variable "high_availability" {
  description = "Enable high availability"
  type        = string
  default     = "Disabled"
}

variable "zone" {
  description = "Availability Zone"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for PostgreSQL server"
  type        = map(string)
  default     = {}
}

variable "databases" {
  description = "List of database names to create"
  type        = list(string)
  default     = []
}

variable "database_collation" {
  description = "Collation setting for databases"
  type        = string
  default     = "en_US.utf8"
}

variable "database_charset" {
  description = "Character set for databases"
  type        = string
  default     = "UTF8"
}

variable "use_existing" {
  description = "Flag to use an existing PostgreSQL server"
  type        = bool
  default     = false
}

variable "existing_server_name" {
  description = "Name of the existing PostgreSQL server"
  type        = string
  default     = null
}
