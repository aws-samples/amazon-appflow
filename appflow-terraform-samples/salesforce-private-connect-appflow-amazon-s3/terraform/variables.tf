## Generic variables

variable "customer" {
  type        = string
  description = "Customer Target PoC"
}

## AppFlow Variables

variable "sfdc_connection_name" {
  type        = string
  description = "AppFlow connector name "
}



### Replication configuration

variable "encryption_key_central_region" {
  type        = string
  description = "Encryption key in central region "
}

variable "replication_time_minutes" {
  description = "The time in minutes within which Amazon S3 must replicate objects"
  type        = number
  default     = 15
}

variable "metric_replication_minutes" {
  description = "The time in minutes after which the replication status is published"
  type        = number
  default     = 15
}