terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

data "template_file" "gcp_json" {
  template = "${file("docker.json")}"
}


provider "docker" {
  registry_auth {
    address  = var.environment.registry
    username = "_json_key"
    password = "${data.template_file.gcp_json.rendered}"
  }
}

resource "docker_image" "img" {
  for_each     = toset(var.images)
  name = each.value
  keep_locally = true
}

resource "docker_tag" "img_tag" {
  for_each     = toset(var.images)
  depends_on = [docker_image.img]
  source_image = each.value
  target_image = "${var.environment.registry}/${var.environment.project_id}/${each.value}"
}

resource "docker_registry_image" "gcp_ubuntu" {
  for_each     = toset(var.images)
  depends_on = [docker_tag.img_tag]
  name = "${var.environment.registry}/${var.environment.project_id}/${each.value}"
}
