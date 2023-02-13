# Create virtual network in gcp
resource "google_compute_network" "main" {
  name                            = "main-network"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.container,
    google_project_service.project
  ]
}

# Create subnets , subnet for services and subnet for pods
resource "google_compute_subnetwork" "private_subnet" {
  name                     = "private-subnet"
  ip_cidr_range            = "10.0.0.0/18"
  region                   = var.project_region
  network                  = google_compute_network.main.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}

# Routing from the internet to the pods and services
resource "google_compute_router" "router" {
  name    = "router"
  region  = "europe-central2"
  network = google_compute_network.main.id
}

# Assign static private ip to the GKE engine
resource "google_compute_address" "staticip" {
  name         = "staticip"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.project]
}

# Enabling NAT to reach the pods and services from the internet
resource "google_compute_router_nat" "nat" {
  name   = "nat"
  router = google_compute_router.router.name
  region = "europe-central2"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.staticip.self_link]
}