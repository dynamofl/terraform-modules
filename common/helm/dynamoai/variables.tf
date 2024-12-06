variable "namespace" {
  description = "Namespace for Nvidia Device Plugin"
  type        = string
  default     = "nvidia-gpu"
}

variable "namespace_created" {
  description = "Flag indicating whether the namespace is created"
  type        = bool
  default     = false
}

variable "chart_version" {
  description = "Version of the Helm chart to deploy"
  type        = string
  default     = "2.14.0"
}

variable "api_domain" {
  description = "API domain for the DynamoAI application"
  type        = string
  default     = "api.dynamoai.local"
}

variable "ui_domain" {
  description = "UI domain for the DynamoAI application"
  type        = string
}

variable "keycloak_domain" {
  description = "Keycloak domain for the DynamoAI application"
  type        = string
}

variable "storage_class" {
  description = "Storage class for the DynamoAI application"
  type        = string
  default     = ""
}

variable "license" {
  description = "License for the DynamoAI application"
  type        = string
  default     = ""
}

variable "postgres_host" {
  description = "Postgres host for the DynamoAI application"
  type        = string
}

variable "kube_config" {
  description = "Kubernetes configuration for the Helm provider"
  type = object({
    host                   = string
    client_certificate     = string
    client_key             = string
    cluster_ca_certificate = string
  })
}

variable "postgres_username" {
  description = "Postgres username for the DynamoAI application"
  type        = string
}

variable "postgres_password" {
  description = "Postgres password for the DynamoAI application"
  type        = string
}

variable "mistral_api_key" {
  description = "Mistral API key for the DynamoAI application"
  type        = string
  default     = ""
}

variable "openai_api_key" {
  description = "OpenAI API key for the DynamoAI application"
  type        = string
  default     = ""
}

variable "data_generation_api_key" {
  description = "Data generation API key for the DynamoAI application"
  type        = string
  default     = ""
}

variable "hf_token" {
  description = "Hugging Face token for the DynamoAI application"
  type        = string
  default     = ""
}

variable "keycloak_username" {
  description = "Keycloak username for the DynamoAI application"
  type        = string
  default     = "admin"
}

variable "keycloak_password" {
  description = "Keycloak password for the DynamoAI application"
  type        = string
  default     = "password"
}
