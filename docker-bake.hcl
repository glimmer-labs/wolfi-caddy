variable "REGISTRY" {
  default = "ghcr.io"
}

variable "IMAGE_OWNER" {
  default = "laravel-glimmer"
}

variable "IMAGE_NAME" {
  default = "wolfi-caddy"
}

variable "WOLFI_DIGEST" {
  default = "latest"
}

target default {
  context = "."
  dockerfile = "Dockerfile"
  platforms = [
    "linux/amd64",
    "linux/arm64",
  ]
  tags = ["${REGISTRY}/${IMAGE_OWNER}/${IMAGE_NAME}:latest"]
  labels = {
      "dev.chainguard.wolfi.digest" = "${WOLFI_DIGEST}",
      "org.opencontainers.image.authors" = "Haruki1707 https://github.com/Haruki1707",
      "org.opencontainers.image.source" = "https://github.com/${IMAGE_OWNER}/${IMAGE_NAME}",
      "org.opencontainers.image.url" = "https://github.com/${IMAGE_OWNER}/${IMAGE_NAME}/pkgs/container/${IMAGE_NAME}",
      "org.opencontainers.image.vendor" = "Laravel Glimmer",
      "org.opencontainers.image.description" = "A Docker image based on Wolfi Linux with a script for installing/building Caddy web server with modules easily.",
  }
}
