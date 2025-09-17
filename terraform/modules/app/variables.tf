variable "gcp_project" {
  type        = string
  description = "Name of the GCP project"
}

variable "dataflow_gcs_bucket" {
  type        = string
  description = "Name of the bucket to use for dataflow"
}
