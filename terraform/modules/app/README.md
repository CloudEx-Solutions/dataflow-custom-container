# Terraform for soi-mlops-video-indexer

### Usage 
Don't use this directly.  Call it as a module from an environment!

### Terraform Module Documention
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.7 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_artifact_registry_repository.my_docker_repo](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/artifact_registry_repository) | resource |
| [google_storage_bucket.dataflow_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dataflow_gcs_bucket"></a> [dataflow\_gcs\_bucket](#input\_dataflow\_gcs\_bucket) | Name of the bucket to use for dataflow | `string` | n/a | yes |
| <a name="input_gcp_project"></a> [gcp\_project](#input\_gcp\_project) | Name of the GCP project | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP region to deploy resources in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataflow_bucket_name"></a> [dataflow\_bucket\_name](#output\_dataflow\_bucket\_name) | n/a |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | Output the URL for use in CI/CD pipelines |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
