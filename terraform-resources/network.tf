module "gcp-network" {
    source       = "terraform-google-modules/network/google"
    version      = "6.0.0"
    project_id   = var.project_id
    network_name = "${var.network}-${var.env_name}"

    subnets = [
        {
            subnet_name   = "${var.subnet_apigw.name}-${var.env_name}"
            subnet_ip     = var.subnet_apigw.subnet_ip
            subnet_region = var.region
        },
        {
            subnet_name   = "${var.subnet_service.name}-${var.env_name}"
            subnet_ip     = var.subnet_service.subnet_ip
            subnet_region = var.region
        },
        {
            subnet_name   = "vm-subnet-${var.env_name}"
            subnet_ip     = var.monitoring_vm_config.subnet_ip
            subnet_region = var.region
        }
    ]

    secondary_ranges = {
        "apigw-subnet-${var.env_name}" = [
            {
                range_name    = var.subnet_apigw.pods_range_name
                ip_cidr_range = var.subnet_apigw.pods_range_ip
            },
            {
                range_name    = var.subnet_apigw.services_range_name
                ip_cidr_range = var.subnet_apigw.services_range_ip
            }
        ],
        "service-subnet-${var.env_name}" = [
            {
                range_name    = var.subnet_service.pods_range_name
                ip_cidr_range = var.subnet_service.pods_range_ip
            },
            {
                range_name    = var.subnet_service.services_range_name
                ip_cidr_range = var.subnet_service.services_range_ip
            }
        ]
    }
}


/*
 * Firewall
*/
resource "google_compute_firewall" "allow-public-to-apigw" {
    name    = "allow-public-to-apigw"
    network = module.gcp-network.network_name

    allow {
        protocol = "tcp"
        ports    = ["443"]
    }

    source_ranges = ["0.0.0.0/0"] # any IP address
    target_tags   = ["${var.apigw_cluster_name}-${var.env_name}"]
}

resource "google_compute_firewall" "allow-gateway-to-service" {
    name    = "allow-gateway-to-service"
    network = module.gcp-network.network_name

    allow {
        protocol = "tcp"
        ports    = ["80", "443"]
    }

    source_ranges = [var.subnet_apigw.subnet_ip] # local subnet
    target_tags   = ["${var.service_cluster_name}-${var.env_name}"]
}

resource "google_compute_firewall" "allow-vm-to-gke" {
    name    = "allow-vm-to-gke"
    network = module.gcp-network.network_name

    allow {
        protocol = "tcp"
        ports    = ["9090", "3000", "9200"]  # Prometheus, Grafana, and ELK
    }

    source_ranges = [var.monitoring_vm_config.subnet_ip]  # VM subnet
    target_tags   = [
        "${var.apigw_cluster_name}-${var.env_name}", 
        "${var.service_cluster_name}-${var.env_name}"
    ]
}

