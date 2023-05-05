variable "project_id" {
  type = string
}

variable "region" {
  type        = string
  description = "The default region for the project"
}

variable "zone" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "subnet_region" {
  type = string
}

variable "subnet_cidr" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "router_name" {
  type = string
}

variable "router_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "vpc_network" {
  type        = string
  description = "VPC network for the GKE cluster"
}

variable "subnet" {
  type        = string
  description = "Subnetwork for the GKE cluster"
}

variable "secondary_range_name" {
  type = string
}

variable "services_range_name" {
  type = string
}

variable "master_cidr_block" {
  type = string
}

variable "tags" {
  description = "Optional tags to be applied on top of the base tags on all resources"
  type        = map(string)
  default     = {}
}