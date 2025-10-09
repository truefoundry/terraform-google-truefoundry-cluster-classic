################################################################################
# Existing Cluster Configuration
################################################################################

variable "use_existing_cluster" {
  description = "Flag to enable the use of an existing GKE cluster or create a new one"
  type        = bool
  default     = false
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
# Cluster Configuration
################################################################################

variable "cluster_name" {
  description = "Name of the cluster. If use_existing_cluster is enabled cluster_name is used to fetch details of existing cluster"
  type        = string
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

variable "cluster_endpoint_public_access" {
  description = "GCP Public CIDRs access enabled. This is kept true initially so that other Truefoundry terraform modules which run on user local can access the api server endpoint."
  type        = bool
  default     = true
}

variable "default_node_pool_config" {
  description = "Default node pool config"
  type = object({
    service_account = optional(string, "default")
    oauth_scopes = optional(list(string), [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ])
    disk_size_gb         = optional(string, "100")
    disk_type            = optional(string, "pd-balanced")
    secure_boot          = optional(bool, true)
    integrity_monitoring = optional(bool, true)
    enable_spot          = optional(bool, false)
  })
  default = {
  }
}
variable "logging_config" {
  description = "Logging config"
  type = object({
    enable_components = optional(list(string), ["SYSTEM_COMPONENTS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER"])
  })
  default = {
    enable_components = ["SYSTEM_COMPONENTS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER"]
  }
}

variable "tags" {
  description = "A map of tags to add to all resources. Tags are key-value pairs used for grouping and filtering"
  type        = map(string)
  default     = {}
}

################################################################################
# Node Pool Configurations
################################################################################

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
  default     = "1.33"
  type        = string

  validation {
    condition     = contains(["1.32", "1.33", "1.34"], var.kubernetes_version)
    error_message = "kubernetes_version must be one of: 1.32, 1.33, 1.34"
  }
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
    machine_type = optional(string, "e2-standard-4")
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
      "class.truefoundry.com/component" = "control-plane"
    })
    taints = optional(object(
      {
        key    = optional(string, "class.truefoundry.com/component")
        value  = optional(string, "control-plane")
        effect = optional(string, "NO_SCHEDULE")
      }
    ), {})
    preemptible = optional(bool, false)
    spot        = optional(bool, false)
  })
  default = {

  }
}

variable "critical_pool_config" {
  description = "Critical node pool config"
  type = object({
    disk_size_gb = optional(string, "100")
    disk_type    = optional(string, "pd-balanced")
    machine_type = optional(string, "e2-standard-4")
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
      "class.truefoundry.com/component" = "critical"
    })
    taints = optional(object(
      {
        key    = optional(string, "class.truefoundry.com/component")
        value  = optional(string, "critical")
        effect = optional(string, "NO_SCHEDULE")
      }
    ), {})
    preemptible = optional(bool, false)
    spot        = optional(bool, false)
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

################################################################################
# Maintenance Policy Configuration
################################################################################

variable "enable_eol_maintenance_exclusion" {
  description = <<-EOT
    Enable automatic End-of-Life (EOL) maintenance exclusion for the GKE cluster.
    
    When set to true (default), this automatically adds maintenance exclusions that prevent
    automatic minor version upgrades and node upgrades during the end-of-life period for
    the specified Kubernetes version. This helps maintain cluster stability by preventing
    automatic upgrades that could potentially cause issues during EOL periods.

    This exclusion is scoped to NO_MINOR_UPGRADES. This will prevent control plane upgrades, 
    but will allow node patch level upgrades.

    The EOL maintenance exclusions are version-specific and include:
    - Kubernetes 1.32: EOL from 2024-06-01 to 2026-04-11
    - Kubernetes 1.33: EOL from 2024-06-01 to 2026-08-03  
    - Kubernetes 1.34: EOL from 2024-06-01 to 2026-10-01
    
    When disabled (false), only user-defined maintenance exclusions from the maintenance_policy
    variable will be applied. This gives you full control over maintenance scheduling.
    
    For more information on GKE release schedules and EOL dates, see:
    https://cloud.google.com/kubernetes-engine/docs/release-schedule
  EOT
  type        = bool
  default     = true
}



variable "maintenance_recurring_window_policy" {
  description = <<-EOT
    Recurring maintenance window for the GKE cluster

    When set to true (default), this automatically adds a recurring maintenance window for the GKE cluster. 
    This helps maintain cluster stability by preventing automatic upgrades that could potentially cause 
    issues during EOL periods.

    The recurring maintenance window default is set to every Saturday and Sunday from 9:00 AM to 9:00 AM.

    When enable_eol_maintenance_exclusion is set to true, this window is used for patch upgrades.
    GKE may apply critical upgrades outside of this window. 
    (https://cloud.google.com/kubernetes-engine/docs/concepts/maintenance-windows-and-exclusions#security-patching)

    See https://cloud.google.com/kubernetes-engine/docs/how-to/maintenance-windows-and-exclusions#maintenance-window-existing_cluster for more information.
  EOT
  type = object({
    start_time = string
    end_time   = string
    recurrence = string
  })
  default = {
    start_time = "2023-10-01T09:00:00Z"
    end_time   = "2023-10-03T09:00:00Z"
    recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
  }
}
