variable "prefix" {
  type        = string
  description = "Prefix for module names"
  default     = "aimurg"
}

variable "postfix" {
  type        = string
  description = "Postfix for module names"
  default     = "eu1"
}

variable "location" {
  type        = string
  description = "Location for modules"
  default     = "East US 2"
}

variable "trino_version" {
  type        = string
  description = "Trino version"
  default     = "0.410.0"
}

variable "enable_trino_cluster" {
  description = "Variable to enable or disable Trino cluster deployment"
  default     = false
}

variable "spark_version" {
  type        = string
  description = "Spark version"
  default     = "3.3.1"
}

variable "enable_spark_cluster" {
  description = "Variable to enable or disable Spark cluster deployment"
  default     = false
}

variable "flink_version" {
  type        = string
  description = "Flink version"
  default     = "1.16.0"
}

variable "enable_flink_cluster" {
  description = "Variable to enable or disable Flink cluster deployment"
  default     = false
}

variable "pool_version" {
  type        = string
  description = "The version of the Azure HDInsight on AKS cluster pool to create."
  default     = "1.0"
}

variable "pool_node_vm_size" {
  type        = string
  description = "VM SKU selected for the cluster pool."
  default     = "Standard_D4as_v4"
}