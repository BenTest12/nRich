# Enabling the google compute api to manage resources remotely
resource "google_project_service" "project" {
  project = var.project_name
  service = "compute.googleapis.com"
}

# Enabling the container API for kubernetes
resource "google_project_service" "container" {
  project = var.project_name
  service = "container.googleapis.com"
}