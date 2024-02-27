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
}