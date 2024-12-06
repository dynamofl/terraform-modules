variable "use_existing_vnet" {
  description = "Flag to use an existing VNet"
  type        = bool
  default     = false
}

variable "vnet_name" {
  description = "Name of the VNet"
  type        = string
  default     = null
}

variable "location" {
  description = "Location for the VNet"
  type        = string
  default     = ""
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
  default     = []
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for the VNet"
  type        = map(string)
  default     = {}
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

variable "existing_vnet_name" {
  description = "Name of the existing VNet"
  type        = string
  default     = null
}

variable "existing_subnet_names" {
  description = "List of existing subnet names within the existing VNet"
  type        = list(string)
  default     = []
}
