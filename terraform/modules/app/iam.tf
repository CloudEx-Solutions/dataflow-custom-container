resource "google_service_account" "dataflow_sa" {
  account_id   = "your-service-account-id"
  display_name = "your-service-account-display-name"
}

resource "google_project_iam_member" "dataflow_worker_role" {
  project = var.gcp_project
  role    = "roles/dataflow.worker"
  member  = google_service_account.dataflow_sa.member
}

resource "google_storage_bucket_iam_member" "dataflow_sa_data_bucket_admin" {
  bucket = var.dataflow_gcs_bucket
  role   = "roles/storage.objectAdmin"
  member = google_service_account.dataflow_sa.member
}

resource "google_project_iam_member" "artifactregistry_reader_role" {
  project = var.gcp_project
  role    = "roles/artifactregistry.reader"
  member  = google_service_account.dataflow_sa.member
}
