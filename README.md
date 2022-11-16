# azure-hdinsight-hilo-templates

This repo shows an example for rolling out a complete HDInsight on AKS environment (aka Project Hilo) via ARM and Terraform.

This includes rollout of the following resources:

- HDInsight Cluster Pool
- HDInsight Cluster (only `trino`,  `flink` and `spark` for now, `interactive` not supported yet)
- Azure Storage Account
- Azure Key Vault
- Virtual Network including a default subnet
- Log Analytics Workspace
- Azure SQL Database
- User Assigned Identity

## Deploy with ARM

1. Download this repo
2. Go to the [Azure portal](https://portal.azure.com/) and sign in
3. From the Azure portal search bar, search for **Deploy a custom template** and then select it from the available options
4. Click on **Build your own template in the editor**
5. From the downloaded artifact, load the appropiate cluster template within the arm folder

See [Getting started with one click deployment](https://review.learn.microsoft.com/en-us/hdinsight-hilo/getting-started?branch=main) for one-click deployment.

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

- The deployment needs to be made in two steps due to Hilo managed resource group name (MRG) limitation: (i) create a cluster pool first and (ii) enable cluster creation (see below) by copying the MRG name e.g. `MC_hdi-ad40b8b9a7514d76a569e20f6fd4eb90_hilo-pool-murggu-eu4_eastus2` to terraform.tfvars.
- Change `enable_trino_cluster`, `enable_flink_cluster` and `enable_spark_cluster` values to deploy any of those clusters in the pool.
- The deployment was tested on wsl (ubuntu).
