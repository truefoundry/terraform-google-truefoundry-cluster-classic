
################################################################################
# Cluster
################################################################################

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = google_container_cluster.cluster.endpoint
}

output "cluster_id" {
  description = "The id of the GKE cluster"
  value       = google_container_cluster.cluster.id
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = element(split("/", google_container_cluster.cluster.id), length(split("/", google_container_cluster.cluster.id)) - 1)
}

output "cluster_master_version" {
  description = "Master version for the cluster"
  value       = google_container_cluster.cluster.master_version
}

output "cluster_secondary_range_name" {
  description = "Cluster secondary range name for pod IPs"
  value       = var.cluster_secondary_range_name
}

output "services_secondary_range_name" {
  description = "Cluster secondry range name for service IPs"
  value       = var.services_secondary_range_name
}