variable "resource_group_name" {
  type    = string
  default = null
}

variable "location" {
  type    = string
  default = ""
}

variable "use_existing_rg" {
  type    = bool
  default = false
}

variable "existing_rg_name" {
  type    = string
  default = null
}

variable "vnet_name" {
  type    = string
  default = null
}

variable "vnet_address_space" {
  type    = list(string)
  default = []
}

variable "use_existing_vnet" {
  type    = bool
  default = false
}

variable "existing_vnet_name" {
  type    = string
  default = null
}

variable "subnets" {
  description = "Subnets configuration if creating a new VNet"
  type = map(object({
    name              = string
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
    delegation = object({
      name         = string
      service_name = string
      actions      = list(string)
    })
  }))
  default = {}
}

variable "existing_subnet_names" {
  description = "List of existing subnet names within the existing VNet"
  type        = list(string)
  default     = []
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = []
}

variable "aks_name" {
  type    = string
  default = null
}

variable "use_existing_aks" {
  type    = bool
  default = false
}

variable "existing_aks_name" {
  type    = string
  default = null
}

variable "postgresql_name" {
  type    = string
  default = null
}

variable "use_existing_postgresql" {
  type    = bool
  default = false
}

variable "existing_postgresql_name" {
  type    = string
  default = null
}

variable "postgresql_databases" {
  type    = list(string)
  default = []
}

variable "dns_zone_name" {
  type    = string
  default = null
}

variable "use_existing_dns_zone" {
  type    = bool
  default = false
}

variable "existing_dns_zone_name" {
  type    = string
  default = null
}
