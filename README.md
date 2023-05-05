# Private GKE Cluster

## Description

- Google Kubernetes Engine in Private Network



## Terraform infrastructure overview

- a vpc, 1 private subnets with secondary range for pods and services, NAT, Router
- private GKE cluster.
- 1 service account for the cluster to manage microbased application



## Steps

- terraform init
- terraform fmt
- terraform validate
- terraform plan
- terraform apply