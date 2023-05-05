terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Create a service account
resource "google_service_account" "gke_service_account" {
  account_id = "gke-service-account"
  project    = var.project_id
}

# Grant minimum required permissions to the service account
resource "google_project_iam_member" "gke_service_account_iam" {
  role        = "roles/container.admin"
  member_type = "serviceAccount"
  member      = google_service_account.gke_service_account.email
}

# Create the GKE cluster
resource "google_container_cluster" "cluster" {
  name                     = var.cluster_name
  location                 = "${var.region}-${var.zone}"
  initial_node_count       = var.initial_node_count
  remove_default_node_pool = true

  master_auth {
    username = ""
    password = ""
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    machine_type = "n1-standard-2"
    service_account = google_service_account.gke_service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    shielded_instance_config {
      enable_secure_boot = true
      enable_integrity_monitoring = true
    }

    workload_metadata_config {
      node_metadata = "SECURE"
    }

    kubelet_config {
      enable_custom_metrics = true
    }
  }

  addons_config {
    network_policy_config {
      enabled = true
    }
  }

  node_pool {
    name             = var.node_pool_name
    machine_type     = "n1-standard-2"
    initial_node_count = 3
    auto_repair      = true
    auto_upgrade     = true

    management {
      auto_repair   = true
      auto_upgrade  = true
    }

    upgrade_settings {
      max_surge      = 1
      max_unavailable = 0
    }

    shielded_instance_config {
      enable_secure_boot = true
      enable_integrity_monitoring = true
    }
  }

  network_config {
    network                   = var.vpc_network
    subnetwork                = var.subnet
    enable_private_nodes      = true
    enable_private_endpoint  = true
  }

  # Set tags for resources
  lifecycle {
    ignore_changes = [
      addons_config,
      node_pool,
      network_config
    ]
    create_before_destroy = true
  }

  master_authorized_networks_config {
    cidr_blocks = [
      "10.0.0.0/8"
    ]
  }

  network_policy {
    enabled = true
    provider = "CALICO"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.secondary_range_name
    services_secondary_range_name = var.services_range_name
  }

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes = true
    master_ipv4_cidr_block = var.master_cidr_block
  }

  pod_security_policy_config {
    enabled = true
  }
}