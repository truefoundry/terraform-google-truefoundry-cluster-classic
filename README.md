# terraform-google-truefoundry-cluster-classic
Truefoundry Google Cloud Cluster Classic Module

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_container_cluster.cluster](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_container_cluster) | resource |
| [google_compute_firewall.fix_webhooks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_container_node_pool.generic](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_generic_node_config"></a> [cluster\_generic\_node\_config](#input\_cluster\_generic\_node\_config) | Cluster Generic Node configuration | `map(any)` | n/a | yes |
| <a name="input_cluster_master_ipv4_cidr_block"></a> [cluster\_master\_ipv4\_cidr\_block](#input\_cluster\_master\_ipv4\_cidr\_block) | Master nodes ipv4 cidr | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_cluster_network_name"></a> [cluster\_network\_name](#input\_cluster\_network\_name) | Network name for the cluster | `string` | n/a | yes |
| <a name="input_cluster_node_locations"></a> [cluster\_node\_locations](#input\_cluster\_node\_locations) | AZ for nodes - this should match the region | `list(string)` | n/a | yes |
| <a name="input_cluster_secondary_range_name"></a> [cluster\_secondary\_range\_name](#input\_cluster\_secondary\_range\_name) | VPC Secondary range name for pods | `string` | `"pods"` | no |
| <a name="input_cluster_subnetwork_id"></a> [cluster\_subnetwork\_id](#input\_cluster\_subnetwork\_id) | Subnetwork name for the cluster. | `string` | n/a | yes |
| <a name="input_enable_container_image_streaming"></a> [enable\_container\_image\_streaming](#input\_enable\_container\_image\_streaming) | Enable/disable container image streaming | `bool` | `true` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP Project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region | `string` | n/a | yes |
| <a name="input_services_secondary_range_name"></a> [services\_secondary\_range\_name](#input\_services\_secondary\_range\_name) | VPC Secondary range name for services | `string` | `"services"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready |
| <a name="output_cluster_master_version"></a> [cluster\_master\_version](#output\_cluster\_master\_version) | Master version for the cluster |
<!-- END_TF_DOCS -->