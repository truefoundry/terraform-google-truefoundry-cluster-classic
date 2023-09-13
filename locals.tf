locals {
  tags = merge({
    "terraform-module" = "truefoundry-cluster-classic"
    "terraform"        = "true"
    "cluster-name"     = var.cluster_name
    },
    var.tags
  )
}