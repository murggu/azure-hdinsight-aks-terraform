# azure-hdinsight-hilo-templates

This repo shows an example for rolling out a complete HDInsight on AKS environment (aka Project Hilo) via Terraform.

This includes rollout of the following resources:

- HDInsight Cluster Pool
- HDInsight Cluster (only `trino`,  `flink` and `spark` for now, `interactive` not supported yet)
- Azure Storage Account
- Azure Key Vault
- Virtual Network including a default subnet
- Log Analytics Workspace
- Azure SQL Database
- User Assigned Identity

## Deploy with Terraform

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
    
### Notes
See notes below for additional info:

- Change `enable_trino_cluster`, `enable_flink_cluster` and `enable_spark_cluster` values to deploy any of those clusters in the pool.
- The deployment was tested on wsl (ubuntu).
