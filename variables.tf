# From https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/variables.tf

################################################################################
# Cluster
################################################################################

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "cluster_node_locations" {
  description = "AZ for nodes - this should match the region"
  type        = list(string)
}

variable "max_pods_per_node" {
  description = "Maximum pods per node"
  default     = "32"
  type        = string
}
variable "cluster_generic_node_config" {
  description = "Cluster Generic Node configuration"
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
    spot                          = optional(bool, false)
  })
  default = {

  }
}

variable "cluster_nap_node_config" {
  description = "Cluster NAP Node configuration"
  type = object({
    disk_size_gb                = optional(string, "300")
    disk_type                   = optional(string, "pd-balanced")
    enable_secure_boot          = optional(bool, true)
    enable_integrity_monitoring = optional(bool, true)
    autoscaling_profile         = optional(string, "OPTIMIZE_UTILIZATION")
    max_cpu                     = optional(number, 1024)
    max_memory                  = optional(number, 1024)
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
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable "kubernetes_version" {
  description = "Version of GKE"
  default     = "1.27"
  type        = string

}

################################################################################
# Network
################################################################################

variable "cluster_network_name" {
  description = "Network name for the cluster"
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
  default     = "notpods"
  type        = string
  description = "VPC Secondary range name for pods"
}

variable "cluster_ipv4_cidr_block" {
  description = "The IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size. Optional with cluster_ipv4_cidr_block"
  type        = string
  default     = ""
}

variable "services_secondary_range_name" {
  default     = ""
  type        = string
  description = "VPC Secondary range name for services"
}

variable "services_ipv4_cidr_block" {
  default     = ""
  description = "The IP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size. Optional with services_secondary_range_name"
  type        = string
}

variable "allowed_ip_ranges" {
  description = "Allowed IP ranges to connect to master"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

################################################################################
# Generic
################################################################################


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "region"
  type        = string
}

variable "project" {
  description = "GCP Project"
  type        = string
}