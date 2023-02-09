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

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = "nrich-terraform.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-range"
    services_secondary_range_name = "service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}

resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

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
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_compute_target_pool" "cluster_target_pool" {
  name = "cluster-target-pool"
  region = "europe-central2"
}

resource "google_compute_forwarding_rule" "load_balancer" {
  name    = "my-gke-lb-rule"
  region  = "europe-central2"
  ip_protocol = "TCP"
  port_range = "80"
  target = google_compute_target_pool.cluster_target_pool.self_link
}

resource "google_service_account" "images-acc" {
  account_id   = "images-acc"
  display_name = "images-acc"
}

resource "google_storage_bucket" "container_registry" {
  name     = "nrich-terraform"
  location = "EU"
}

resource "google_container_registry" "container_registry" {
  project = "nrich-terraform"
  location = "EU"
}