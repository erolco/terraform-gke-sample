variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "initial_node_count" {
  type    = number
  default = 1
}

variable "node_pool_name" {
  type    = string
  default = "test-node-pool"
}

variable "vpc_network" {
  type = string
  description = "VPC network for the GKE cluster"
}

variable "subnet" {
  type = string
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
