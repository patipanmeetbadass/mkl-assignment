/*
 * GCE for provisioning a VM instance
 * And install script for Prometheus, Grafana, Jenkins, ELK-stack as a system service
*/
resource "google_compute_instance" "monitoring_vm" {
    name         = "monitoring-vm-poc"
    machine_type = var.monitoring_vm_config.machine_type
    zone         = var.monitoring_vm_config.zone

    boot_disk {
        initialize_params {
            image = var.monitoring_vm_config.image
        }
    }

    network_interface {
        network    = module.gcp-network.network_name
        subnetwork = "vm-subnet-${var.env_name}"
        access_config {} # Enables outbound internet access
    }

        metadata_startup_script = <<EOT
        #!/bin/bash
        set -e  # Exit on any error

        # Update system and install dependencies
        sudo apt update -y
        sudo apt install -y curl wget gnupg software-properties-common apt-transport-https lsb-release

        # Install Prometheus
        sudo useradd --no-create-home --shell /bin/false prometheus
        sudo mkdir -p /etc/prometheus /var/lib/prometheus
        cd /tmp
        wget https://github.com/prometheus/prometheus/releases/latest/download/prometheus-linux-amd64.tar.gz
        tar xvf prometheus-linux-amd64.tar.gz
        sudo mv prometheus-*/prometheus /usr/local/bin/
        sudo mv prometheus-*/promtool /usr/local/bin/
        sudo chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool
        sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOF
        [Unit]
        Description=Prometheus Monitoring
        After=network.target

        [Service]
        User=prometheus
        ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml --storage.tsdb.path=/var/lib/prometheus
        Restart=always

        [Install]
        WantedBy=multi-user.target
        EOF
        sudo systemctl daemon-reload
        sudo systemctl enable --now prometheus

        # Install Grafana
        sudo apt install -y grafana
        sudo systemctl enable --now grafana-server

        # Install Jenkins
        wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
        echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
        sudo apt update -y
        sudo apt install -y openjdk-11-jdk jenkins
        sudo systemctl enable --now jenkins

        # Install Elasticsearch
        wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
        sudo add-apt-repository "deb https://artifacts.elastic.co/packages/8.x/apt stable main"
        sudo apt update -y
        sudo apt install -y elasticsearch
        sudo systemctl enable elasticsearch
        sudo systemctl start elasticsearch

        # Install Kibana
        sudo apt install -y kibana
        sudo systemctl enable kibana
        sudo systemctl start kibana

        # Install Logstash
        sudo apt install -y logstash
        sudo systemctl enable logstash
        sudo systemctl start logstash
    EOT
}