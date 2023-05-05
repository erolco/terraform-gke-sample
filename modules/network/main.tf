terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  project                         = var.project_id
  name                            = var.vpc_name
  auto_create_subnetworks         = false
  description                     = "VPC Network for GKE Cluster"
  delete_default_routes_on_create = false
}

# Create a private subnet
resource "google_compute_subnetwork" "subnet" {
  name                     = var.subnet_name
  region                   = var.subnet_region
  network                  = google_compute_network.vpc_network.self_link
  ip_cidr_range            = var.subnet_cidr

  secondary_ip_range {
    range_name    = "gke-private-services"
    ip_cidr_range = "10.101.0.0/16"
  }

  secondary_ip_range {
    range_name    = "gke-private-pods"
    ip_cidr_range = "10.201.0.0/16"
  }
  private_ip_google_access = true
}

# Create a NAT gateway
resource "google_compute_router" "cloud_router" {
  name    = var.router_name
  region  = var.router_region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat" {
  name                               = var.nat_name
  router                             = google_compute_router.cloud_router.name
  region                             = google_compute_router.cloud_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}