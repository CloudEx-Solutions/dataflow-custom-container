module "app" {
  source              = "./modules/app"
  dataflow_gcs_bucket = "your-dataflow-bucket"
  gcp_region          = local.gcp_region
}
