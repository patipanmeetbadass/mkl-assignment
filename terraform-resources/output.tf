output "gke_apigw_cluster_name" {
    description = "GKE api gw Cluster name"
    value       = module.gke_apigw.name
}

output "gke_service_cluster_name" {
    description = "GKE service gw Cluster name"
    value       = module.gke_service.name
}

output "gce_vm_instance_name" {
    description = "GCE VM instance name"
    value       = resource.google_compute_instance.monitoring_vm.name
}