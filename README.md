# Dynamo AI Azure Terraform Module

## Overview
The Dynamo AI Azure Terraform Module is designed to provision the necessary Azure resources to host and deploy the Dynamo AI application. This includes setting up foundational infrastructure such as resource groups, virtual networks, AKS clusters, PostgreSQL databases, and Helm-based deployments.

The modular architecture ensures flexibility, scalability, and ease of management by breaking configurations into reusable components.

---

## Features
This module provisions and configures the following:

### Infrastructure Components
- **Resource Groups**: Organized containers for your resources.
- **Virtual Network (VNet)**: Isolated network for AKS and PostgreSQL.
- **Subnets**: Segmented virtual network space for AKS and PostgreSQL.
- **Azure Kubernetes Service (AKS)**: Fully managed Kubernetes cluster with scaling node pools.
- **PostgreSQL Database**: Managed flexible PostgreSQL server for data storage.

### Helm Charts
- **Dynamo AI Application**: Deployed using Helm for Kubernetes-native package management.
- **NVIDIA Device Plugin**: GPU resource management in AKS.
- **OpenTelemetry**: Distributed tracing and observability.

---

## Prerequisites
- Azure CLI installed and authenticated.
- Terraform v1.0+ installed on your machine.

---

## Usage

### 1. Clone the Repository
```bash
git clone <repository-url>
cd azure
```

### 2. Initialize Terraform
```bash
terraform init
```

### 3. Configure Variables
Create a `.tfvars` file or use the provided `sample.tfvars` file:
```plaintext
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
```

### 4. Apply Terraform Configuration
```bash
terraform apply -var-file=sample.tfvars
```

### 5. Verify Deployment
Check the output for key resource information such as the AKS cluster endpoint and PostgreSQL server.

---

## Module Structure

### Resource Group Module
Manages the creation or reuse of a resource group.

### Virtual Network Module
Configures VNets and subnets, enabling network isolation for AKS and PostgreSQL.

### AKS Module
Creates a Kubernetes cluster with:
- Default node pool
- GPU-enabled node pools for ML workloads

### PostgreSQL Module
Sets up a flexible PostgreSQL database server with DNS integration.

### Helm Modules
Deploys essential components, including Dynamo AI, NVIDIA GPU plugin, and OpenTelemetry, using Helm charts.

---

## Outputs
This module provides key outputs, including:
- AKS cluster details (kubeconfig, DNS endpoint)
- PostgreSQL server details (host, username, password)
- Helm chart configurations

---

## Contributing
We welcome contributions! Please submit pull requests or issues for any enhancements or fixes.

---

## License
This project is licensed under the Apache License 2.0. See the `LICENSE` file for details.

