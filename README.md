# terraform-google-truefoundry-cluster-classic
Truefoundry Google Cloud Cluster Classic Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.81.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | 4.82.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.81.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 4.82.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_container_cluster.cluster](https://registry.terraform.io/providers/hashicorp/google-beta/4.82.0/docs/resources/google_container_cluster) | resource |
| [google_compute_firewall.fix_webhooks](https://registry.terraform.io/providers/hashicorp/google/4.81.0/docs/resources/compute_firewall) | resource |
| [google_container_node_pool.generic](https://registry.terraform.io/providers/hashicorp/google/4.81.0/docs/resources/container_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ip_ranges"></a> [allowed\_ip\_ranges](#input\_allowed\_ip\_ranges) | Allowed IP ranges to connect to master | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_cluster_generic_node_config"></a> [cluster\_generic\_node\_config](#input\_cluster\_generic\_node\_config) | Cluster Generic Node configuration | <pre>object({<br>    disk_size_gb                  = optional(string, "100")<br>    disk_type                     = optional(string, "pd-balanced")<br>    machine_type                  = optional(string, "e2-medium")<br>    enable_secure_boot            = optional(bool, true)<br>    enable_integrity_monitoring   = optional(bool, true)<br>    auto_repair                   = optional(bool, true)<br>    auto_upgrade                  = optional(bool, true)<br>    node_count                    = optional(number, 1)<br>    workload_metadata_config_mode = optional(string, "GKE_METADATA")<br>    service_account               = optional(string, "default")<br>    preemptible                   = optional(bool, false)<br>    spot                          = optional(bool, false)<br>  })</pre> | `{}` | no |
| <a name="input_cluster_ipv4_cidr_block"></a> [cluster\_ipv4\_cidr\_block](#input\_cluster\_ipv4\_cidr\_block) | The IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size. Optional with cluster\_ipv4\_cidr\_block | `string` | `""` | no |
| <a name="input_cluster_master_ipv4_cidr_block"></a> [cluster\_master\_ipv4\_cidr\_block](#input\_cluster\_master\_ipv4\_cidr\_block) | Master nodes ipv4 cidr | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_cluster_nap_node_config"></a> [cluster\_nap\_node\_config](#input\_cluster\_nap\_node\_config) | Cluster NAP Node configuration | <pre>object({<br>    disk_size_gb                = optional(string, "300")<br>    disk_type                   = optional(string, "pd-balanced")<br>    enable_secure_boot          = optional(bool, true)<br>    enable_integrity_monitoring = optional(bool, true)<br>    autoscaling_profile         = optional(string, "OPTIMIZE_UTILIZATION")<br>    max_cpu                     = optional(number, 1024)<br>    max_memory                  = optional(number, 1024)<br>    auto_repair                 = optional(bool, true)<br>    auto_upgrade                = optional(bool, true)<br>    max_surge                   = optional(number, 1)<br>    max_unavailable             = optional(number, 0)<br>  })</pre> | `{}` | no |
| <a name="input_cluster_network_name"></a> [cluster\_network\_name](#input\_cluster\_network\_name) | Network name for the cluster | `string` | n/a | yes |
| <a name="input_cluster_networking_mode"></a> [cluster\_networking\_mode](#input\_cluster\_networking\_mode) | Networking mode for the cluster. Values can be VPC\_NATIVE (recommended) or ROUTES | `string` | `"VPC_NATIVE"` | no |
| <a name="input_cluster_node_locations"></a> [cluster\_node\_locations](#input\_cluster\_node\_locations) | AZ for nodes - this should match the region | `list(string)` | n/a | yes |
| <a name="input_cluster_secondary_range_name"></a> [cluster\_secondary\_range\_name](#input\_cluster\_secondary\_range\_name) | VPC Secondary range name for pods | `string` | `"notpods"` | no |
| <a name="input_cluster_subnet_id"></a> [cluster\_subnet\_id](#input\_cluster\_subnet\_id) | Subnetwork name for the cluster. | `string` | n/a | yes |
| <a name="input_enable_container_image_streaming"></a> [enable\_container\_image\_streaming](#input\_enable\_container\_image\_streaming) | Enable/disable container image streaming | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Version of GKE | `string` | `"1.27"` | no |
| <a name="input_max_pods_per_node"></a> [max\_pods\_per\_node](#input\_max\_pods\_per\_node) | Maximum pods per node | `string` | `"32"` | no |
| <a name="input_oauth_scopes"></a> [oauth\_scopes](#input\_oauth\_scopes) | Oauth Scopes to attach to the cluste | `list(string)` | <pre>[<br>  "https://www.googleapis.com/auth/cloud-platform",<br>  "https://www.googleapis.com/auth/devstorage.read_only",<br>  "https://www.googleapis.com/auth/logging.write",<br>  "https://www.googleapis.com/auth/monitoring.write"<br>]</pre> | no |
| <a name="input_project"></a> [project](#input\_project) | GCP Project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region | `string` | n/a | yes |
| <a name="input_services_ipv4_cidr_block"></a> [services\_ipv4\_cidr\_block](#input\_services\_ipv4\_cidr\_block) | The IP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size. Optional with services\_secondary\_range\_name | `string` | `""` | no |
| <a name="input_services_secondary_range_name"></a> [services\_secondary\_range\_name](#input\_services\_secondary\_range\_name) | VPC Secondary range name for services | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready |
| <a name="output_cluster_ipv4_cidr_block"></a> [cluster\_ipv4\_cidr\_block](#output\_cluster\_ipv4\_cidr\_block) | IPv4 CIDR block for pods |
| <a name="output_cluster_master_version"></a> [cluster\_master\_version](#output\_cluster\_master\_version) | Master version for the cluster |
| <a name="output_cluster_secondary_range_name"></a> [cluster\_secondary\_range\_name](#output\_cluster\_secondary\_range\_name) | Cluster secondary range name for pod IPs |
| <a name="output_services_ipv4_cidr_block"></a> [services\_ipv4\_cidr\_block](#output\_services\_ipv4\_cidr\_block) | IPv4 CIDR block for service |
| <a name="output_services_secondary_range_name"></a> [services\_secondary\_range\_name](#output\_services\_secondary\_range\_name) | Cluster secondry range name for service IPs |
<!-- END_TF_DOCS -->