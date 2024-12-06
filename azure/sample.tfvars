subscription_id = "value"
resource_group_name = "dynamoai-rg"
location = "eastus"
use_existing_rg = true
existing_rg_name = "dynamoai-rg"

vnet_name = "dynamoai-vnet"
vnet_address_space = ["10.0.0.0/16"]
use_existing_vnet = true
existing_vnet_name = "dynamoai-vnet"
existing_subnet_names = [ "dynamoai-aks-subnet", "dynamoai-rds-subnet" ]

aks_name = "test-cluster"
use_existing_aks = false
existing_aks_name = ""

postgresql_name = "dynamo-postgresql"
use_existing_postgresql = false
existing_postgresql_name = ""
postgresql_databases = ["dynamoai", "keycloak"]

dns_zone_name = "dynamoai.com"
use_existing_dns_zone = true
existing_dns_zone_name = "dynamoai.com"
