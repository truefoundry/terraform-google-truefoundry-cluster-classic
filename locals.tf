locals {
  tags = merge({
    "terraform-module" = "gcp"
    "terraform"        = "true"
    "cluster-name"     = var.cluster_name
    },
    var.tags
  )
}