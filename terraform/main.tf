module "app" {
  source              = "./modules/app"
  gcp_project         = local.gcp_project
  dataflow_gcs_bucket = "your-dataflow-bucket"
}
