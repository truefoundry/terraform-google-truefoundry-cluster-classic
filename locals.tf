locals {
  tags = merge({
    "terraform-module" = "truefoundry-cluster-classic"
    "terraform"        = "true"
    "cluster-name"     = var.cluster_name
    "truefoundry"      = "managed"
    },
    var.tags
  )
  generic_tags = merge({
    node_usage = "generic"
    },
    local.tags
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
  generic_network_tags       = concat(["generic"], var.network_tags)
  control_plane_network_tags = concat(["tfy-control-plane"], var.network_tags)
  critical_pool_network_tags = concat(["tfy-critical"], var.network_tags)
  nap_network_tags           = concat(["tfy-nap"], var.network_tags)
}