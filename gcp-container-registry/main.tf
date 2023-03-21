terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  registry_auth {
    address  = var.environment.registry
    username = "_json_key"
    password = var.GCP_REGISTRY_TOKEN
  }
  registry_auth {
    address  = var.environment.ocp_registry
    username = "system-serviceaccount-d893f6-tools-github-cicd"
    password = var.OCP_SA_TOKEN
  }
}

resource "docker_image" "docker_img" {
  for_each   = {
  for index, img in var.images:
    join("", [img.image, img.ocp_tag]) => img
  }
  name = "${each.value.image}${each.value.ocp_tag}"
  keep_locally = true
}

resource "docker_tag" "img_tag" {
  for_each   = {
  for index, img in var.images:
    join("", [img.image, img.ocp_tag]) => img
  }
  depends_on = [docker_image.docker_img]
  source_image = "${each.value.image}${each.value.ocp_tag}"
  target_image = "${var.environment.registry}/${var.environment.project_id}/${each.value.image}${each.value.gcp_tag != "" ? each.value.gcp_tag : each.value.ocp_tag}"
}

resource "docker_registry_image" "gcp_ubuntu" {
  for_each   = {
  for index, img in var.images:
    join("", [img.image, img.ocp_tag]) => img
  }
  depends_on = [docker_tag.img_tag]
  name = "${var.environment.registry}/${var.environment.project_id}/${each.value.image}${each.value.gcp_tag != "" ? each.value.gcp_tag : each.value.ocp_tag}"
}
