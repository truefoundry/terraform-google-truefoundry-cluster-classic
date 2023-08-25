resource "google_container_cluster" "cluster" {
  provider       = google-beta
  project        = var.project
  name           = var.cluster_name
  location       = var.region
  node_locations = var.cluster_node_locations

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  min_master_version = "1.26"

  network    = var.cluster_network_name
  subnetwork = var.cluster_subnetwork_id

  cluster_autoscaling {
    enabled = true
    resource_limits {
      maximum       = 1000
      minimum       = 1
      resource_type = "cpu"
    }
    resource_limits {
      maximum       = 1000
      minimum       = 1
      resource_type = "memory"
    }
    auto_provisioning_defaults {
      service_account = "default"
    }

  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.cluster_master_ipv4_cidr_block
  }

  # Enable Autopilot for this cluster
  # enable_autopilot = false

  # Configuration of cluster IP allocation for VPC-native clusters
  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  release_channel {
    channel = "REGULAR"
  }
  vertical_pod_autoscaling {
    enabled = true
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  node_pool_defaults {
    node_config_defaults {
      gcfs_config {
        enabled = true 
      }
    }
  }
}

# Customizable node pool
# See: https://registry.terraform.io/providers/hashicorp/google/4.1.0/docs/resources/container_node_pool
resource "google_container_node_pool" "generic" {
  name           = "generic"
  cluster        = google_container_cluster.cluster.id
  location       = var.region
  node_locations = var.cluster_node_locations
  node_count     = 1

  node_config {
    preemptible  = false
    machine_type = var.cluster_generic_node_config["machine_type"]

    disk_size_gb = var.cluster_generic_node_config["disk_size_gb"]
    disk_type    = var.cluster_generic_node_config["disk_type"]

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    tags = ["generic"]

    gcfs_config {
      enabled = true
    }
  }

  autoscaling {
    max_node_count = 10
    min_node_count = 1
  }


  depends_on = [
    google_container_cluster.cluster
  ]
}

/******************************************
  CRD are broken in GKE
  https://github.com/kubernetes/kubernetes/issues/79739
 *****************************************/
resource "google_compute_firewall" "fix_webhooks" {
  # count       = var.add_cluster_firewall_rules || var.add_master_webhook_firewall_rules ? 1 : 0
  name        = "${var.cluster_name}-webhook"
  description = "Allow Nodes access to Control Plane"
  project     = var.project
  network     = var.cluster_network_name
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

  depends_on = [
    google_container_cluster.cluster
  ]
}