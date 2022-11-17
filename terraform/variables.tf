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

variable "enable_trino_cluster" {
  description = "Variable to enable or disable Trino cluster deployment"
  default     = false
}

variable "enable_spark_cluster" {
  description = "Variable to enable or disable Spark cluster deployment"
  default     = false
}

variable "enable_interactive_cluster" {
  description = "Variable to enable or disable Interactive cluster deployment"
  default     = false
}

variable "enable_flink_cluster" {
  description = "Variable to enable or disable Flink cluster deployment"
  default     = false
}