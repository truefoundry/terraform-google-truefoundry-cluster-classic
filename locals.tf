locals {
  tags = merge({
    "terraform-module" = "truefoundry-cluster-classic"
    "terraform"        = "true"
    "cluster-name"     = var.cluster_name
    "truefoundry"      = "managed"
    },
    var.tags
  )
  control_plane_tags = merge({
    node_usage = "tfy-control-plane"
    },
    local.tags
  )
  critical_pool_tags = merge({
    node_usage = "tfy-critical"
    },
    local.tags
  )
  control_plane_network_tags = concat(["tfy-control-plane"], var.network_tags)
  critical_pool_network_tags = concat(["tfy-critical"], var.network_tags)
  nap_network_tags           = concat(["tfy-nap"], var.network_tags)

  # Version EOL maintenance exclusion mapping
  maintenance_version_eol_exclusions_eol_mapping = {
    "1.32" = {
      exclusion_name = "no_minor_control_plane_upgrades"
      start_time     = "2024-06-01T00:00:00Z"
      end_time       = "2026-04-11T00:00:00Z"
      scope          = "NO_MINOR_UPGRADES"
    }
    "1.33" = {
      exclusion_name = "no_minor_control_plane_upgrades"
      start_time     = "2024-06-01T00:00:00Z"
      end_time       = "2026-08-03T00:00:00Z"
      scope          = "NO_MINOR_UPGRADES"
    }
    "1.34" = {
      exclusion_name = "no_minor_control_plane_upgrades"
      start_time     = "2024-06-01T00:00:00Z"
      end_time       = "2026-10-01T00:00:00Z"
      scope          = "NO_MINOR_UPGRADES"
    }
  }
}
