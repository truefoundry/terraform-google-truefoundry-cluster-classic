data "google_container_cluster" "existing_cluster" {
  count    = var.use_existing_cluster ? 1 : 0
  name     = var.cluster_name
  location = var.region
  project  = var.project
}

# Needed to build the GKE service agent identity that publishes cluster notifications
data "google_project" "current" {
  count      = local.create_cluster_notification_topic ? 1 : 0
  project_id = var.project
}
