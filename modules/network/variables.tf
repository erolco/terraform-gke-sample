variable "project_id" {
  type = string
}

variable "region" {
  type        = string
  description = "The default region for the project"
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

variable "tags" {
  description = "Optional tags to be applied on top of the base tags on all resources"
  type        = map(string)
  default     = {}
}