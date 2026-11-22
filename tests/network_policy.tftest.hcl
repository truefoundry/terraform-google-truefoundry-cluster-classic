# Uses mock providers + plan-only runs so no GCP credentials are required.

mock_provider "google" {}
mock_provider "google-beta" {}

variables {
  cluster_name                   = "tfy-test"
  region                         = "us-central1"
  project                        = "tfy-test-project"
  cluster_node_locations         = ["us-central1-a"]
  cluster_network_id             = "projects/tfy-test-project/global/networks/tfy-test"
  cluster_subnet_id              = "projects/tfy-test-project/regions/us-central1/subnetworks/tfy-test"
  cluster_master_ipv4_cidr_block = "172.16.0.0/28"
}

# Existing clusters must not get either block by default.
run "network_policy_default_omitted" {
  command = plan

  assert {
    condition     = length(google_container_cluster.cluster[0].network_policy) == 0
    error_message = "network_policy must not be set by default"
  }

  assert {
    condition     = length(google_container_cluster.cluster[0].addons_config[0].network_policy_config) == 0
    error_message = "addons_config.network_policy_config must not be set by default"
  }
}

run "network_policy_enabled" {
  command = plan

  variables {
    enable_network_policy = true
  }

  assert {
    condition     = google_container_cluster.cluster[0].network_policy[0].enabled == true
    error_message = "network_policy.enabled must be true"
  }

  assert {
    condition     = google_container_cluster.cluster[0].network_policy[0].provider == "CALICO"
    error_message = "network_policy.provider must be CALICO"
  }

  assert {
    condition     = google_container_cluster.cluster[0].addons_config[0].network_policy_config[0].disabled == false
    error_message = "NetworkPolicy addon must be enabled"
  }
}
