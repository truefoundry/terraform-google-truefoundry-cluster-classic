data "google_container_cluster" "existing_cluster" {
  count    = var.use_existing_cluster ? 1 : 0
  name     = var.cluster_name
  location = var.region
  project  = var.project
}
