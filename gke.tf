# See: https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/container_cluster
resource "google_container_cluster" "cluster" {
  provider                    = google-beta
  project                     = var.project
  name                        = var.cluster_name
  description                 = "Truefoundry kubernetes cluster"
  location                    = var.region
  node_locations              = var.cluster_node_locations
  default_max_pods_per_node   = var.max_pods_per_node
  deletion_protection         = var.deletion_protection
  remove_default_node_pool    = true
  initial_node_count          = 1
  networking_mode             = var.cluster_networking_mode
  min_master_version          = var.kubernetes_version
  network                     = var.cluster_network_id
  subnetwork                  = var.cluster_subnet_id
  enable_shielded_nodes       = true
  enable_intranode_visibility = true
  resource_labels             = local.tags
  cluster_autoscaling {
    enabled = true
    resource_limits {
      maximum       = var.cluster_nap_node_config.max_cpu
      minimum       = 0
      resource_type = "cpu"
    }
    resource_limits {
      maximum       = var.cluster_nap_node_config.max_memory
      minimum       = 0
      resource_type = "memory"
    }
    resource_limits {
      maximum       = 256
      minimum       = 0
      resource_type = "nvidia-tesla-k80"
    }
    resource_limits {
      resource_type = "nvidia-tesla-p100"
      minimum       = 0
      maximum       = 256
    }
    resource_limits {
      resource_type = "nvidia-tesla-p4"
      minimum       = 0
      maximum       = 256
    }
    resource_limits {
      resource_type = "nvidia-tesla-v100"
      minimum       = 0
      maximum       = 256
    }
    resource_limits {
      resource_type = "nvidia-tesla-t4"
      minimum       = 0
      maximum       = 256
    }
    resource_limits {
      resource_type = "nvidia-tesla-a100"
      minimum       = 0
      maximum       = 256
    }
    resource_limits {
      resource_type = "nvidia-a100-80gb"
      minimum       = 0
      maximum       = 256
    }
    resource_limits {
      resource_type = "nvidia-l4"
      minimum       = 0
      maximum       = 256
    }
    auto_provisioning_defaults {
      service_account = "default"
      oauth_scopes    = var.oauth_scopes
      disk_size       = var.cluster_nap_node_config.disk_size_gb
      disk_type       = var.cluster_nap_node_config.disk_type
      shielded_instance_config {
        enable_secure_boot          = var.cluster_nap_node_config.enable_secure_boot
        enable_integrity_monitoring = var.cluster_nap_node_config.enable_integrity_monitoring
      }
      management {
        auto_upgrade = var.cluster_nap_node_config.auto_repair
        auto_repair  = var.cluster_nap_node_config.auto_upgrade
      }
      upgrade_settings {
        strategy        = "SURGE"
        max_surge       = var.cluster_nap_node_config.max_surge
        max_unavailable = var.cluster_nap_node_config.max_unavailable
      }
    }
    autoscaling_profile = var.cluster_nap_node_config.autoscaling_profile
  }
  node_pool_auto_config {
    network_tags {
      tags = local.nap_network_tags
    }
  }
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "APISERVER", "CONTROLLER_MANAGER", "SCHEDULER"]
  }

  maintenance_policy {
    recurring_window {
      start_time = "2023-10-01T09:00:00Z"
      end_time   = "2023-10-03T09:00:00Z"
      recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.allowed_ip_ranges
      content {
        cidr_block = cidr_blocks.value
      }

    }
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }
  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }
  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.cluster_master_ipv4_cidr_block
    master_global_access_config {
      enabled = false
    }
  }
  cost_management_config {
    enabled = true
  }

  # Enable Autopilot for this cluster
  # enable_autopilot = false

  # Configuration of cluster IP allocation for VPC-native clusters
  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  release_channel {
    channel = "STABLE"
  }
  vertical_pod_autoscaling {
    enabled = false
  }

  node_pool_defaults {
    node_config_defaults {
      gcfs_config {
        enabled = var.enable_container_image_streaming
      }
    }
  }
}

# Customizable node pool
# See: https://registry.terraform.io/providers/hashicorp/google/4.1.0/docs/resources/container_node_pool

##########################################################################################
## Generic node pool
##########################################################################################
resource "google_container_node_pool" "generic" {
  count          = var.cluster_generic_node_config.enabled ? 1 : 0
  name           = "generic"
  cluster        = google_container_cluster.cluster.id
  location       = var.region
  node_locations = var.cluster_node_locations
  management {
    auto_repair  = var.cluster_generic_node_config.auto_repair
    auto_upgrade = var.cluster_generic_node_config.auto_upgrade
  }
  node_count = var.cluster_generic_node_config.node_count

  node_config {
    disk_size_gb = var.cluster_generic_node_config.disk_size_gb
    disk_type    = var.cluster_generic_node_config.disk_type
    gcfs_config {
      enabled = var.enable_container_image_streaming
    }

    machine_type = var.cluster_generic_node_config.machine_type
    shielded_instance_config {
      enable_secure_boot          = var.cluster_generic_node_config.enable_secure_boot
      enable_integrity_monitoring = var.cluster_generic_node_config.enable_integrity_monitoring
    }
    workload_metadata_config {
      mode = var.cluster_generic_node_config.workload_metadata_config_mode
    }
    oauth_scopes    = var.oauth_scopes
    preemptible     = var.cluster_generic_node_config.preemptible
    spot            = var.cluster_generic_node_config.spot
    service_account = var.cluster_generic_node_config.service_account

    tags            = local.generic_network_tags
    resource_labels = local.generic_tags
  }
}

##########################################################################################
## Control plane node pool
##########################################################################################
resource "google_container_node_pool" "control_plane_pool" {
  count          = var.control_plane_enabled ? 1 : 0
  name           = "control-plane"
  cluster        = google_container_cluster.cluster.id
  location       = var.region
  node_locations = var.cluster_node_locations
  management {
    auto_repair  = var.control_plane_pool_config.auto_repair
    auto_upgrade = var.control_plane_pool_config.auto_upgrade
  }
  autoscaling {
    min_node_count  = var.control_plane_pool_config.autoscaling.min_node_count
    max_node_count  = var.control_plane_pool_config.autoscaling.max_node_count
    location_policy = var.control_plane_pool_config.autoscaling.location_policy
  }
  node_config {
    disk_size_gb = var.control_plane_pool_config.disk_size_gb
    disk_type    = var.control_plane_pool_config.disk_type
    gcfs_config {
      enabled = var.enable_container_image_streaming
    }
    labels = var.control_plane_pool_config.labels
    taint {
      key    = var.control_plane_pool_config.taints.key
      value  = var.control_plane_pool_config.taints.value
      effect = var.control_plane_pool_config.taints.effect
    }
    resource_labels = local.control_plane_tags
    machine_type    = var.control_plane_pool_config.machine_type
    shielded_instance_config {
      enable_secure_boot          = var.control_plane_pool_config.enable_secure_boot
      enable_integrity_monitoring = var.control_plane_pool_config.enable_integrity_monitoring
    }
    workload_metadata_config {
      mode = var.control_plane_pool_config.workload_metadata_config_mode
    }
    oauth_scopes    = var.oauth_scopes
    preemptible     = var.control_plane_pool_config.preemptible
    spot            = var.control_plane_pool_config.spot
    service_account = var.control_plane_pool_config.service_account

    tags = local.control_plane_network_tags

  }
}


/******************************************
  CRD are broken in GKE
  https://github.com/kubernetes/kubernetes/issues/79739
#  *****************************************/
resource "google_compute_firewall" "fix_webhooks" {
  # count       = var.add_cluster_firewall_rules || var.add_master_webhook_firewall_rules ? 1 : 0
  count       = var.shared_vpc ? 0 : 1
  name        = "${var.cluster_name}-webhook"
  description = "Allow Nodes access to Control Plane"
  project     = var.project
  network     = var.cluster_network_id
  priority    = 1000
  direction   = "INGRESS"

  source_ranges = [
    "${google_container_cluster.cluster.endpoint}/32",
    var.cluster_master_ipv4_cidr_block
  ]

  allow {
    protocol = "tcp"
    ports    = ["443", "8443", "9443", "15017"]
  }
}