/*
 * Namespace in GKE cluster for api gateway
*/
provider "kubernetes" {
    alias         = "apigw"
    host          = module.gke_apigw.endpoint
    token         = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke_apigw.ca_certificate)
}

resource "kubernetes_namespace" "apigw_poc" {
    provider = kubernetes.apigw
    metadata {
        name = "apigw-poc"
    }
}


/*
 * Namespace in GKE cluster for service
*/
provider "kubernetes" {
    alias         = "service"
    host          = module.gke_service.endpoint
    token         = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke_service.ca_certificate)
}

resource "kubernetes_namespace" "service_poc" {
    provider = kubernetes.service
    metadata {
        name = "service-poc"
    }
}

resource "kubernetes_namespace" "database_poc" {
    provider = kubernetes.service
    metadata {
        name = "database-poc"
    }
}
