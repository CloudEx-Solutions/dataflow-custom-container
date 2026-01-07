
variable "dataflow_gcs_bucket" {
  type        = string
  description = "Name of the bucket to use for dataflow"
}

variable "gcp_region" {
  type        = string
  description = "GCP region to deploy resources in"
}
