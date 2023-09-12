
################################################################################
# Cluster
################################################################################

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = google_container_cluster.cluster.endpoint
}

output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = google_container_cluster.cluster.id
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
output "cluster_ipv4_cidr_block" {
  description = "IPv4 CIDR block for pods"
  value       = var.cluster_ipv4_cidr_block
}
output "services_ipv4_cidr_block" {
  description = "IPv4 CIDR block for service"
  value       = var.services_ipv4_cidr_block
}