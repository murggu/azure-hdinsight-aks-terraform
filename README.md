# azure-hdinsight-hilo-terraform

This repo shows an example for rolling out a complete nextgen HDInsight environment (codename Hilo, HDInsight on AKS) via Terraform.

[TODO add architecture]

This includes rollout of the following resources:

- HDInsight Cluster Pool
- HDInsight Cluster (only `trino`,  `flink` and `spark` for now, see below)
- Azure Storage Account
- Azure Key Vault
- Virtual Network including a default subnet
- Log Analytics Workspace
- Azure SQL Database
- User Assigned Identity

## Instructions

Make sure you have the [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) and [Terraform](https://www.terraform.io/downloads.html) installed. 

1. Go to `terraform` folder
2. Copy `terraform.tfvars.example` to `terraform.tfvars`
3. Update `terraform.tfvars` with your desired values
4. Run Terraform
    ```console
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```
    
## Notes
See notes below for additional info:

- The deployment needs to be made in two steps due to Hilo managed resource group name (MRG) limitation: (i) create a cluster pool first and (ii) enable cluster creation (see below) by copying the MRG name e.g. `MC_hdi-ad40b8b9a7514d76a569e20f6fd4eb90_hilo-pool-murggu-eu4_eastus2` to terraform.tfvars.
- Change `enable_trino_cluster`, `enable_flink_cluster` and `enable_spark_cluster` values to deploy any of those clusters in the pool.
- The deployment was tested on wsl (ubuntu).
