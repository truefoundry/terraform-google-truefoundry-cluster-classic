# Regression tests for INFRA-900: ensure the NAP auto_provisioning_defaults
# management block wires auto_upgrade/auto_repair to their matching variables
# (they were previously swapped).
#
# Uses mock providers + plan-only runs so no GCP credentials are required.

mock_provider "google" {}
mock_provider "google-beta" {}

# Required inputs shared by every run. Values are placeholders — the cluster is
# never actually provisioned (command = plan).
variables {
  cluster_name                   = "tfy-test"
  region                         = "us-central1"
  project                        = "tfy-test-project"
  cluster_node_locations         = ["us-central1-a"]
  cluster_network_id             = "projects/tfy-test-project/global/networks/tfy-test"
  cluster_subnet_id              = "projects/tfy-test-project/regions/us-central1/subnetworks/tfy-test"
  cluster_master_ipv4_cidr_block = "172.16.0.0/28"
}

# Key regression: distinct values for auto_repair and auto_upgrade so a swap is
# detectable. Fails on the pre-fix code where the two were crossed.
run "nap_management_distinct_values" {
  command = plan

  variables {
    cluster_nap_node_config = {
      auto_repair  = false
      auto_upgrade = true
    }
  }

  assert {
    condition     = google_container_cluster.cluster[0].cluster_autoscaling[0].auto_provisioning_defaults[0].management[0].auto_upgrade == true
    error_message = "NAP auto_provisioning_defaults.management.auto_upgrade must match var.cluster_nap_node_config.auto_upgrade (expected true)"
  }

  assert {
    condition     = google_container_cluster.cluster[0].cluster_autoscaling[0].auto_provisioning_defaults[0].management[0].auto_repair == false
    error_message = "NAP auto_provisioning_defaults.management.auto_repair must match var.cluster_nap_node_config.auto_repair (expected false)"
  }
}

# Sanity check: defaults leave both flags enabled.
run "nap_management_defaults" {
  command = plan

  assert {
    condition     = google_container_cluster.cluster[0].cluster_autoscaling[0].auto_provisioning_defaults[0].management[0].auto_upgrade == true
    error_message = "NAP auto_provisioning_defaults.management.auto_upgrade should default to true"
  }

  assert {
    condition     = google_container_cluster.cluster[0].cluster_autoscaling[0].auto_provisioning_defaults[0].management[0].auto_repair == true
    error_message = "NAP auto_provisioning_defaults.management.auto_repair should default to true"
  }
}
