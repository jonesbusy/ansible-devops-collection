resource "docker_image" "traefik" {
  name  = "traefik:${var.traefik_version}"
  lifecycle {
    prevent_destroy = false
  }
}

# Network
resource "docker_network" "traefik" {
  name = "traefik"
  ipam_config {
    subnet  = "172.21.0.0/16"
    gateway  = "172.21.0.1"
  }
  lifecycle {
    prevent_destroy = false
  }
}

# Postgres containers
resource "docker_container" "traefik" {
  image    = docker_image.traefik.latest
  name     = "traefik"
  restart  = "unless-stopped"
  hostname = "traefik"
  labels {
    label = "co.elastic.logs/module"
    value = "traefik"
  }
  labels {
    label = "co.elastic.logs/fileset.stdout"
    value = "access"
  }
  labels {
    label = "co.elastic.logs/fileset.stderr"
    value = "error"
  }
  # HTTP
  ports {
    internal = var.http_port
    external = var.external_http_port
  }
  # HTTPS
  ports {
    internal = var.https_port
    external = var.external_https_port
  }
  # TCP
  ports {
    internal = var.tcp_port
    external = var.external_tcp_port
  }
  # Docker socket
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
    read_only      = true
  }
  # Configurations
  volumes {
    host_path      = abspath("${var.docker_templates_folder}/configs/traefik.yml")
    container_path = "/etc/traefik/traefik.yml"
  }
  # Services
  volumes {
    host_path      = abspath("${var.docker_templates_folder}/configs/services.yml")
    container_path = "/opt/services.yml"
  }
  # Certificate
  volumes {
    host_path      = abspath("${var.docker_templates_folder}/traefik-cert.pem")
    container_path = "/opt/${var.hostname}.pem"
    read_only      = true
  }
  # Key
  volumes {
    host_path      = abspath("${var.docker_templates_folder}/traefik-cert.key")
    container_path = "/opt/${var.hostname}.key"
    read_only      = true
  }
  # Root CA
  volumes {
    host_path      = abspath("${var.docker_templates_folder}/configs/traefik-ca.pem")
    container_path = "/opt/rootca.pem"
    read_only      = true
  }
  networks_advanced {
    name = docker_network.traefik.name
  }

}