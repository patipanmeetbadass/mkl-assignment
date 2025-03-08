terraform {
    required_providers {
        google = {
        source = "hashicorp/google"
        version = "4.47.0"
        }
    }
}

provider "kubernetes" {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}