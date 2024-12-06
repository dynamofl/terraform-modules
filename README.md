# Dynamo AI Azure Terraform Module 

## Overview
The `dynamoai` Terraform module creates all necessary resources for a Dynamo AI K8s cluster on Microsoft Azure, and deploys the DynamoAI application on the cluster through helm. The configurations include setting up a resource group, virtual network, subnets, AKS (Azure Kubernetes Service) cluster, Node Pools, PostgreSQL database, and storage accounts. 

## Directory Structure
- `dynamoai/`
  - `tfvars/`
    - `dynamoai-azure-default.tfvars`: Contains default variable values for the Terraform configurations.
  - `aks.tf`: Defines the Azure Kubernetes Service (AKS) cluster, node pools, and resource group.
  - `network.tf`: Configures the virtual network and subnets for AKS and PostgreSQL services.
  - `storage.tf`: Sets up the Azure Storage account and blob container for persistent storage.
  - `rds.tf`: Manages the PostgreSQL flexible server, private DNS zone, and DNS link to the virtual network.
  - `identity.tf`: Handles role assignments for the AKS cluster and storage access permissions.
  - `helm.tf`: Deploys the DynamoAI application via Helm in the AKS cluster. 

## Configuration Details
This repository deploys the following resources on Microsoft Azure:
- Resource Group
- Virtual Network with Subnets
- AKS (Azure Kubernetes Service) Cluster
- PostgreSQL Database
- Storage Account with Container

## Usage
1. Clone the repository:
   ```sh
   git clone <repository-url>
   cd azure-terraform
   ```
2. Enter the Subscription ID in `provider.tf`

3. Point the terraform helm to the helm chart you want to deploy, in `helm.tf`:
   ```
   chart  = <Relative path to the Chart.yaml >
   values = <Relative path to the values.yaml>
   ```

4. Initialize Terraform:
   ```sh
   terraform init
   ```

5. Apply the Terraform configurations:
   ```sh
   terraform apply -var-file=tfvars/dynamoai-azure-default.tfvars
   ```

## Prerequisites
- Terraform installed on your local machine.
- Azure CLI installed and authenticated.

## Contributing
Please submit issues and pull requests for any improvements or bug fixes.

## License
This project is licensed under the Apache License.