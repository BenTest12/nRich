![DiagramName](terraform.png)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.52.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_address.staticip](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/compute_address) | resource |
| [google_compute_network.main](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/compute_network) | resource |
| [google_compute_router.router](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/compute_router) | resource |
| [google_compute_router_nat.nat](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/compute_router_nat) | resource |
| [google_compute_subnetwork.private_subnet](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/compute_subnetwork) | resource |
| [google_container_cluster.main](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/container_cluster) | resource |
| [google_container_node_pool.pool](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/container_node_pool) | resource |
| [google_container_registry.container_registry](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/container_registry) | resource |
| [google_project_service.container](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/project_service) | resource |
| [google_project_service.project](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/project_service) | resource |
| [google_service_account.kubernetes](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/service_account) | resource |
| [google_storage_bucket.container_registry](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.storageAdmin](https://registry.terraform.io/providers/hashicorp/google/4.52.0/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_location"></a> [cluster\_location](#input\_cluster\_location) | Variable to store cluster location | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Variable to store cluster name | `string` | n/a | yes |
| <a name="input_credentials_file"></a> [credentials\_file](#input\_credentials\_file) | Google cloud authentication file | `string` | n/a | yes |
| <a name="input_node_count"></a> [node\_count](#input\_node\_count) | Variable to gke node count | `number` | n/a | yes |
| <a name="input_oauth_scopes"></a> [oauth\_scopes](#input\_oauth\_scopes) | Variable to store oauth scope list | `list(string)` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Variable to store project name | `string` | n/a | yes |
| <a name="input_project_region"></a> [project\_region](#input\_project\_region) | Variable to store project region | `string` | n/a | yes |

## Outputs

No outputs.
