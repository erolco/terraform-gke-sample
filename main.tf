terraform {
  backend "gcs" {
    bucket = "my-terraform-gke-bucket"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.10"
    }
  }
}

locals {
  base_tags = {
    Environment     = "production"
    Terraform       = "true"
  }
}

provider "google" {
  region      = var.region
  project     = var.project_id
  credentials = file("xxxxxxxxxxxxxxxxx.json")
  zone        = "${var.region}-${var.zone}"

}

module "network" {
  source = "./modules/network"

  project_id               = var.project_id
  region                   = var.region
  vpc_name                 = var.vpc_name
  subnet_region            = var.subnet_region
  subnet_cidr              = var.subnet_cidr
  nat_name                 = var.nat_name
  router_name              = var.router_name
  router_region            = var.region
  tags                     = var.local.base_tags
}

module "gke" {
  source = "./modules/gke"

  project_id          = var.project_id
  region              = var.region
  cluster_name        = var.cluster_name
  vpc_network         = module.network.vpc_network
  subnet              = module.network.subnet
  ip_allocation_policy {
    cluster_secondary_range_name  = var.secondary_range_name
    services_secondary_range_name = var.services_range_name
  }
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes = true
    master_ipv4_cidr_block = var.master_cidr_block
  }
  tags                    = var.local.base_tags
}

