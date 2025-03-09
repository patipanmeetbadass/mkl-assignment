/*
 * GKE cluster for api gateway
 * And authentication (kubeconfig)
*/
module "gke_apigw" {
    source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
    version                = "24.1.0"
    project_id             = var.project_id
    name                   = "${var.apigw_cluster_name}-${var.env_name}"
    regional               = true
    region                 = var.region
    network                = module.gcp-network.network_name
    subnetwork             = "apigw-subnet-${var.env_name}"
    ip_range_pods          = var.ip_range_pods_name
    ip_range_services      = var.ip_range_services_name
    
    node_pools = [
        {
        name                      = "node-pool"
        machine_type              = var.gke_module_config.machine_type
        node_locations            = var.zones
        min_count                 = 1
        max_count                 = 2
        disk_size_gb              = 20
        tags                      = "${var.apigw_cluster_name}-${var.env_name}"
        },
    ]
}

module "gke_auth_apigw" {
    source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
    version = "24.1.0"
    depends_on   = [module.gke_apigw]
    project_id   = var.project_id
    location     = module.gke_apigw.location
    cluster_name = module.gke_apigw.name
}

resource "local_file" "kubeconfig_gke_apigw" {
    content  = module.gke_auth_apigw.kubeconfig_raw
    filename = "kubeconfig-${module.gke_apigw.name}"
}


/*
 * GKE cluster for microservices
 * And authentication (kubeconfig)
*/
module "gke_service" {
    source                 = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
    version                = "24.1.0"
    project_id             = var.project_id
    name                   = "${var.service_cluster_name}-${var.env_name}"
    regional               = true
    region                 = var.region
    network                = module.gcp-network.network_name
    subnetwork             = "service-subnet-${var.env_name}"
    ip_range_pods          = var.ip_range_pods_name
    ip_range_services      = var.ip_range_services_name
    
    node_pools = [
        {
        name                      = "node-pool"
        machine_type              = var.gke_module_config.machine_type
        node_locations            = var.zones
        min_count                 = 1
        max_count                 = 2
        disk_size_gb              = 20
        tags                      = "${var.service_cluster_name}-${var.env_name}"
        },
    ]
}

module "gke_auth_service" {
    source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
    version = "24.1.0"
    depends_on   = [module.gke_service]
    project_id   = var.project_id
    location     = module.gke_service.location
    cluster_name = module.gke_service.name
}

resource "local_file" "kubeconfig_gke_service" {
    content  = module.gke_auth_service.kubeconfig_raw
    filename = "kubeconfig-${module.gke_service.name}"
}