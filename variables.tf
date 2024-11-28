################################################################################
# Existing Cluster Configuration
################################################################################

variable "use_existing_cluster" {
  description = "Flag to enable the use of an existing GKE cluster or create a new one"
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "Name of the cluster. If use_existing_cluster is enabled name is used to fetch details of existing cluster"
  type        = string
}

variable "cluster_node_locations" {
  description = "AZ for nodes - this should match the region"
  type        = list(string)
}

variable "max_pods_per_node" {
  description = "Maximum number of pods per node in this cluster."
  default     = "32"
  type        = string
}

################################################################################
# General Cluster Configuration
################################################################################

variable "tags" {
  description = "A map of tags to add to all resources. Tags are key-value pairs used for grouping and filtering"
  type        = map(string)
  default     = {}
}

variable "network_tags" {
  description = "A list of network tags to add to all instances"
  type        = list(string)
  default     = []
}

variable "region" {
  description = "region"
  type        = string
}

variable "project" {
  description = "GCP Project"
  type        = string
}


################################################################################
# Node Pool Configurations
################################################################################

variable "cluster_generic_node_config" {
  description = <<-EOT
    Configuration for the generic node pool. This includes:
    - disk_size_gb: Size of the disk attached to each node (default: "100")
    - disk_type: Type of disk attached to each node (pd-standard, pd-balanced, pd-ssd) (default: "pd-balanced")
    - machine_type: The name of a Google Compute Engine machine type (default: "e2-medium")
    - enable_secure_boot: Secure Boot helps ensure that the system only runs authentic software (default: true)
    - enable_integrity_monitoring: Enables monitoring and attestation of the boot integrity (default: true)
    - auto_repair: Flag to enable auto repair for the nodes (default: true)
    - auto_upgrade: Flag to enable auto upgrade for the nodes (default: true)
    - node_count: The number of nodes per instance group (default: 1)
    - workload_metadata_config_mode: How to expose metadata to workloads running on the node (default: "GKE_METADATA")
    - service_account: The Google Cloud Platform Service Account (default: "default")
    - preemptible: Flag to enable preemptible nodes (default: false)
    - spot: Flag to enable spot instances (default: true)
  EOT
  type = object({
    disk_size_gb                  = optional(string, "100")
    disk_type                     = optional(string, "pd-balanced")
    machine_type                  = optional(string, "e2-medium")
    enable_secure_boot            = optional(bool, true)
    enable_integrity_monitoring   = optional(bool, true)
    auto_repair                   = optional(bool, true)
    auto_upgrade                  = optional(bool, true)
    node_count                    = optional(number, 1)
    workload_metadata_config_mode = optional(string, "GKE_METADATA")
    service_account               = optional(string, "default")
    preemptible                   = optional(bool, false)
    spot                          = optional(bool, true)
  })
  default = {}
}

variable "cluster_nap_node_config" {
  description = <<-EOT
    Configuration for the NAP node pool. This includes:
    - disk_size_gb: Size of the disk attached to each node (default: "300")
    - disk_type: Type of disk attached to each node (pd-standard, pd-balanced, pd-ssd) (default: "pd-balanced")
    - enable_secure_boot: Secure Boot helps ensure that the system only runs authentic software (default: true)
    - enable_integrity_monitoring: Enables monitoring and attestation of the boot integrity (default: true)
    - autoscaling_profile: Profile for autoscaling optimization (default: "OPTIMIZE_UTILIZATION")
    - max_cpu: Maximum CPU cores allowed per node (default: 1024)
    - max_memory: Maximum memory in MB allowed per node (default: 8172)
    - auto_repair: Flag to enable auto repair for the nodes (default: true)
    - auto_upgrade: Flag to enable auto upgrade for the nodes (default: true)
    - max_surge: Maximum number of nodes that can be created beyond the current size during updates (default: 1)
    - max_unavailable: Maximum number of nodes that can be unavailable during updates (default: 0)
  EOT
  type = object({
    disk_size_gb                = optional(string, "300")
    disk_type                   = optional(string, "pd-balanced")
    enable_secure_boot          = optional(bool, true)
    enable_integrity_monitoring = optional(bool, true)
    autoscaling_profile         = optional(string, "OPTIMIZE_UTILIZATION")
    max_cpu                     = optional(number, 1024)
    max_memory                  = optional(number, 8172)
    auto_repair                 = optional(bool, true)
    auto_upgrade                = optional(bool, true)
    max_surge                   = optional(number, 1)
    max_unavailable             = optional(number, 0)
  })
  default = {

  }
}

variable "enable_container_image_streaming" {
  description = "Enable/disable container image streaming"
  type        = bool
  default     = true
}

variable "oauth_scopes" {
  description = "Oauth Scopes to attach to the cluste"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/trace.append"
  ]
}

variable "kubernetes_version" {
  description = "Version of GKE"
  default     = "1.28"
  type        = string
}

variable "deletion_protection" {
  description = "Deletion protection enabled/disabled"
  default     = false
  type        = bool
}

variable "control_plane_enabled" {
  description = "Whether control plane is enabled or not"
  default     = false
  type        = bool
}

variable "control_plane_pool_config" {
  description = "Control plane node pool config"
  type = object({
    disk_size_gb = optional(string, "100")
    disk_type    = optional(string, "pd-balanced")
    machine_type = optional(string, "e2-medium")
    autoscaling = optional(object({
      min_node_count  = optional(number, 1)
      max_node_count  = optional(number, 2)
      location_policy = optional(string, "BALANCED")
    }), {})
    enable_secure_boot            = optional(bool, true)
    enable_integrity_monitoring   = optional(bool, true)
    auto_repair                   = optional(bool, true)
    auto_upgrade                  = optional(bool, true)
    workload_metadata_config_mode = optional(string, "GKE_METADATA")
    service_account               = optional(string, "default")
    labels = optional(map(string), {
      "class.truefoundry.io/component" = "control-plane"
    })
    taints = optional(object(
      {
        key    = optional(string, "class.truefoundry.io/component")
        value  = optional(string, "control-plane")
        effect = optional(string, "NO_SCHEDULE")
      }
    ), {})
    preemptible = optional(bool, false)
    spot        = optional(bool, true)
  })
  default = {

  }
}
################################################################################
# Network Configuration
################################################################################

variable "shared_vpc" {
  description = "Flag to enable shared VPC"
  type        = bool
  default     = false
}

variable "cluster_network_id" {
  description = "Network ID for the cluster"
  type        = string
}

variable "cluster_subnet_id" {
  description = "Subnetwork name for the cluster."
  type        = string
}

variable "cluster_networking_mode" {
  description = "Networking mode for the cluster. Values can be VPC_NATIVE (recommended) or ROUTES. VPC_NATIVE is default after google-beta 5.0.0"
  type        = string
  default     = "VPC_NATIVE"
}

variable "cluster_master_ipv4_cidr_block" {
  description = "Master nodes ipv4 cidr"
  type        = string
}

variable "cluster_secondary_range_name" {
  default     = ""
  type        = string
  description = "VPC Secondary range name for pods"
}

variable "services_secondary_range_name" {
  default     = ""
  type        = string
  description = "VPC Secondary range name for services"
}

variable "allowed_ip_ranges" {
  description = "Allowed IP ranges to connect to master"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}
