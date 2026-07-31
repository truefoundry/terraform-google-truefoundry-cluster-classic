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
  control_plane_network_tags = concat(["tfy-control-plane"], var.network_tags, var.control_plane_pool_config.network_tags)
  critical_pool_network_tags = concat(["tfy-critical"], var.network_tags, var.critical_pool_config.network_tags)
  nap_network_tags           = concat(["tfy-nap"], var.network_tags)

  additional_node_pools = var.use_existing_cluster ? {} : var.additional_node_pools

  additional_node_pool_tags = {
    for name, config in local.additional_node_pools : name => merge(
      { node_usage = name },
      try(config.resource_labels, {}),
      local.tags,
    )
  }

  additional_node_pool_network_tags = {
    for name, config in local.additional_node_pools : name => concat(
      var.network_tags,
      coalesce(config.network_tags, []),
    )
  }

  cluster_notifications_enabled     = !var.use_existing_cluster && var.cluster_notification_config.enabled
  create_cluster_notification_topic = local.cluster_notifications_enabled && var.cluster_notification_config.topic_id == null
  cluster_notification_topic_id = (
    local.create_cluster_notification_topic
    ? one(google_pubsub_topic.cluster_notifications[*].id)
    : var.cluster_notification_config.topic_id
  )

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
    "1.35" = {
      exclusion_name = "no_minor_control_plane_upgrades"
      start_time     = "2024-06-01T00:00:00Z"
      end_time       = "2027-04-11T00:00:00Z"
      scope          = "NO_MINOR_UPGRADES"
    }
  }
}
