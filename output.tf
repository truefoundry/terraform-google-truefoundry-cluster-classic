
################################################################################
# Cluster
################################################################################

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = var.use_existing_cluster ? data.google_container_cluster.existing_cluster[0].endpoint : google_container_cluster.cluster[0].endpoint
}

output "cluster_id" {
  description = "The id of the GKE cluster"
  value       = var.use_existing_cluster ? data.google_container_cluster.existing_cluster[0].id : google_container_cluster.cluster[0].id
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = var.use_existing_cluster ? data.google_container_cluster.existing_cluster[0].name : google_container_cluster.cluster[0].name
}

output "cluster_master_version" {
  description = "Master version for the cluster"
  value       = var.use_existing_cluster ? data.google_container_cluster.existing_cluster[0].master_version : google_container_cluster.cluster[0].master_version
}

output "cluster_secondary_range_name" {
  description = "Cluster secondary range name for pod IPs"
  value       = var.cluster_secondary_range_name
}

output "services_secondary_range_name" {
  description = "Cluster secondry range name for service IPs"
  value       = var.services_secondary_range_name
}
