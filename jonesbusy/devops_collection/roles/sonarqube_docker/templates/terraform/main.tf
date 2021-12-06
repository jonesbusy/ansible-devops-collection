resource "docker_image" "sonarqube" {
  name = "sonarqubejonesbusy"
  build {
    path       = "../files"
    dockerfile = var.sonarqube_dockerfile
    build_arg = {
      "sonarqube_version" = var.sonarqube_version
    }
  }
  lifecycle {
    prevent_destroy = false
  }
}

resource "docker_image" "postgres" {
  name = "postgres:${var.postgresql_version}"
  lifecycle {
    prevent_destroy = false
  }
}

# Provision volumes
resource "docker_volume" "sonarqube-logs" {
  name = "sonarqube-logs"
  lifecycle {
    prevent_destroy = false
  }
}

resource "docker_volume" "postgres" {
  name = "postgres"
  lifecycle {
    prevent_destroy = false
  }
}

# Postgres containers
resource "docker_container" "postgres" {
  image    = docker_image.postgres.latest
  name     = "postgres"
  restart  = "unless-stopped"
  hostname = "postgres"
  ports {
    external = 5432
    internal = 5432
  }
  env = [
    "POSTGRES_DB=${var.postgresql_db}",
    "POSTGRES_USER=${var.postgresql_username}",
    "POSTGRES_PASSWORD=${var.postgresql_password}",
  ]
  volumes {
    volume_name    = docker_volume.postgres.id
    container_path = "/var/lib/postgresql/data"
  }
  networks_advanced {
    name = var.external_network_name
  }
  lifecycle {
    prevent_destroy = false
  }
}

# Sonarqube
resource "docker_container" "sonarqube" {
  image    = docker_image.sonarqube.latest
  name     = "sonarqube"
  restart  = "unless-stopped"
  hostname = "sonarqube"
  env = [
    "JAVA_TOOL_OPTIONS=-Djava.awt.headless=true",
  ]
  # Configurations
  volumes {
    host_path      = abspath("${var.docker_templates_folder}/configs/sonar.properties")
    container_path = "/opt/sonarqube/conf/sonar.properties"
    read_only      = true
  }
  volumes {
    host_path      = abspath("${var.docker_templates_folder}/sonarqube-truststore.jks")
    container_path = "/opt/sonarqube/sonarqube-truststore.jks"
    read_only      = true
  }
  volumes {
    volume_name    = docker_volume.sonarqube-logs.id
    container_path = "/opt/sonarqube/logs"
  }
  labels {
    label = "traefik.enable"
    value = "true"
  }
  labels {
    label = "traefik.http.middlewares.add-sonarqube-path.addprefix.prefix"
    value = "/sonarqube"
  }
  labels {
    label = "traefik.http.routers.sonarqubeuiroot.middlewares"
    value = "add-sonarqube-path@docker"
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.services.${labels.value["name"]}.loadbalancer.server.port"
      value = labels.value["port"]
    }
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.routers.${labels.value["name"]}.entrypoints"
      value = labels.value["entrypoint"]
    }
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.routers.${labels.value["name"]}.tls"
      value = true
    }
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.routers.${labels.value["name"]}.service"
      value = labels.value["name"]
    }
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.routers.${labels.value["name"]}.rule"
      value = "Host(`${labels.value["host"]}`) && PathPrefix(`${labels.value["path_prefix"]}`)"
    }
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.services.${labels.value["name"]}.loadbalancer.healthcheck.hostname"
      value = "sonarqube"
    }
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.services.${labels.value["name"]}.loadbalancer.healthcheck.port"
      value = labels.value["port"]
    }
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.services.${labels.value["name"]}.loadbalancer.healthcheck.interval"
      value = "10s"
    }
  }
  dynamic "labels" {
    for_each = var.docker_environment_hosts
    content {
      label = "traefik.http.services.${labels.value["name"]}.loadbalancer.healthcheck.timeout"
      value = "5"
    }
  }
  networks_advanced {
    name = var.external_network_name
  }
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      log_opts
    ]
  }
  depends_on = [docker_container.postgres]
}