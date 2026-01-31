module "app" {
  source              = "./modules/app"
  dataflow_gcs_bucket = "your-dataflow-bucket"
  gcp_region          = local.gcp_region
}
output "registry_url" {
  value = module.app.repository_url
}
output "dataflow_bucket_name" {
  value = module.app.dataflow_bucket_name
}
