# Create a kubernetes cluster with the name main 
# In the europe-central2 location with one node and 
# Apply network configurations configured here and in the VPC.tf file

resource "google_container_cluster" "main" {
  name                     = "main"
  location                 = "europe-central2"
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private_subnet.self_link
  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"
  networking_mode          = "VPC_NATIVE"

  # Disable software loadbalancing
  addons_config {
    http_load_balancing {
      disabled = true
    }
  }

  # Receive latest kubernetes version on each creation
  release_channel {
    channel = "REGULAR"
  }

  # Workload service account to manage the cluster
  workload_identity_config {
    workload_pool = "${var.project_name}.svc.id.goog"
  }

  # Network subnet to communicate between the pods in the cluster
  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "service-range"
  }

  # Set up a private kubernetes cluster with a public ip
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}

# 
resource "google_container_node_pool" "pool" {
  name       = "pool"
  cluster    = google_container_cluster.main.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = "e2-small"

    labels = {
      role = "pool"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_write",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

# Creating a service account to manage the cluster
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

resource "google_compute_target_pool" "cluster_target_pool" {
  name = "cluster-target-pool"
  region = "europe-central2"
}

resource "google_storage_bucket" "container_registry" {
  name     = var.project_name
  location = "EU"
}

resource "google_container_registry" "container_registry" {
  project = var.project_name
  location = "EU"
}

resource "google_service_account" "images-acc" {
  account_id   = "images-acc"
  project = var.project_name
}

resource "google_storage_bucket_iam_member" "viewer" {
  bucket = google_container_registry.container_registry.id
  role = "roles/storage.admin"
  member =  "serviceAccount:${google_service_account.kubernetes.email}"
  #member = "serviceAccount:${google_service_account.images-acc.email}"
}

resource "google_compute_address" "external_ip" {
  name = "external-ip"
  region = "europe-central2"
}

resource "google_compute_forwarding_rule" "cluster_forwarding_rule" {
  name    = "cluster-forwarding-rule"
  region  = "europe-central2"
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_pool.cluster_target_pool.self_link
  ip_address = google_compute_address.external_ip.address
}

# resource "google_compute_firewall" "private_access" {
#   name    = "private-access"
#   network = module.gke_cluster.network_name

#   allow {
#     protocol = "tcp"
#     ports    = ["30000-32767"]
#   }
# }

resource "google_compute_forwarding_rule" "cluster_forwarding_rule2" {
  name    = "cluster-forwarding-rule2"
  region  = "europe-central2"
  ip_protocol = "TCP"
  port_range = "30000-32767"
  target = google_compute_target_pool.cluster_target_pool.self_link
  ip_address = google_compute_address.external_ip.address
}