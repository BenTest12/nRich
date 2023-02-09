resource "google_project_service" "project" {
  project = var.project_name
  service = "compute.googleapis.com"
}

resource "google_project_service" "container" {
  project = var.project_name
  service = "container.googleapis.com"
}