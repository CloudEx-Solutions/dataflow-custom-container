resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "google_storage_bucket" "dataflow_bucket" {
  name     = "${var.dataflow_gcs_bucket}-${random_id.bucket_suffix.hex}"
  location = var.gcp_region

  uniform_bucket_level_access = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30
    }
  }
  depends_on = [random_id.bucket_suffix]
}

output "dataflow_bucket_name" {
  value = google_storage_bucket.dataflow_bucket.name
}
