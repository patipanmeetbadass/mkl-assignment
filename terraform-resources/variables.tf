variable "project_id" {
    description = "The project ID to host the cluster in"
}
variable "apigw_cluster_name" {
    description = "The name for the GKE cluster"
    default     = "apigw"
}
variable "service_cluster_name" {
    description = "The name for the GKE cluster"
    default     = "service"
}
variable "env_name" {
    description = "The environment for the GKE cluster"
    default     = "poc"
}
variable "region" {
    description = "The region to host the cluster in"
    default     = "asia-southeast1"
}
variable "zones" {
    description = "Zones in region"
    default     = "asia-southeast1-a,asia-southeast1-b,asia-southeast1-c"
}
variable "network" {
    description = "The VPC network created to host the cluster in"
    default     = "gke-network"
}
variable "subnetwork" {
    description = "The subnetwork created to host the cluster in"
    default     = "gke-subnet"
}
variable "ip_range_pods_name" {
    description = "The secondary ip range to use for pods"
    default     = "ip-range-pods"
}
variable "ip_range_services_name" {
    description = "The secondary ip range to use for services"
    default     = "ip-range-services"
}

variable "gke_module_config" {
    description = "gke_module_config"
    type        = object({
        machine_type  = string
    })
    default = {
        machine_type  = "e2-medium"
    }
}

variable "monitoring_vm_config" {
    description = "gke_module_config"
    type        = object({
        name            = string
        machine_type    = string
        image           = string
        zone            = string
        subnet_ip       = string
    })
    default = {
        name            = "monitoring-vm"
        machine_type    = "e2-small"
        image           = "ubuntu-2004-lts"
        zone            = "asia-southeast1-a"
        subnet_ip       = "10.90.1.0/24"
    }
}

variable "subnet_apigw" {
    description = "subnet for GKE apigw"
    type        = object({
        name                = string
        subnet_ip           = string
        pods_range_name     = string
        services_range_name = string
        pods_range_ip       = string
        services_range_ip   = string
    })
    default = {
        name                = "apigw-subnet"
        pods_range_name     = "apigw-pods-range"
        services_range_name = "apigw-services-range"
        subnet_ip           = "10.10.0.0/16"
        pods_range_ip       = "10.10.1.0/20"
        services_range_ip   = "10.10.16.0/20"
    }
}

variable "subnet_service" {
    description = "subnet for GKE service"
    type        = object({
        name                = string
        subnet_ip           = string
        pods_range_name     = string
        services_range_name = string
        pods_range_ip       = string
        services_range_ip   = string
    })
    default = {
        name                = "service-subnet"
        pods_range_name     = "service-pods-range"
        services_range_name = "service-services-range"
        subnet_ip           = "10.20.0.0/16"
        pods_range_ip       = "10.20.1.0/20"
        services_range_ip   = "10.20.16.0/20"
    }
}

