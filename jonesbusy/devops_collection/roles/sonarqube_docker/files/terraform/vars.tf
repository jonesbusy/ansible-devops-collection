# Docker provider config
variable "docker_host" {
  type    = string
  default = "unix:///var/run/docker.sock"
}

variable "traefik_version" {
  type        = string
  description = "Version of traefik to deploy"
  default     = "v2.5.4"
}

# Ports
variable "scheme" {
  type        = string
  description = "Scheme to access application"
  default     = "http"
}

variable "http_port" {
  type        = number
  description = "Port to access web frontent from the docker network"
  default     = 80
}

variable "external_http_port" {
  type        = number
  description = "Port to access web frontent from the docker host"
  default     = 80
}

variable "https_port" {
  type        = number
  description = "Port to access web frontent from the docker network"
  default     = 443
}

variable "external_https_port" {
  type        = number
  description = "Port to access web frontent from the docker host"
  default     = 443
}

variable "tcp_port" {
  type        = number
  description = "Port to access tcp from the docker network"
  default     = 30000
}

variable "external_tcp_port" {
  type        = number
  description = "Port to access tcp from the docker host"
  default     = 30000
}

# Infra
variable "hostname" {
  type = string
}

# Docker build / config
variable "docker_templates_folder" {
  type = string
  default = "../docker"
}

# Environment hosts
variable "traefik_extra_entrypoints" {
  description = "Extra entrypoint"
  type = list(object({
    name = string
    port = number
  }))
  default     = []
}