variable "environment" {
  type = object({
    project_id     = string
    registry       = string
    ocp_registry   = string
  })
  description = "GCP project parameters"

  default = {
    project_id      = "c4hnrd-dev"
    registry        = "gcr.io"
    ocp_registry    = "image-registry.apps.silver.devops.gov.bc.ca"
  }
}

variable "OCP_SA_TOKEN" {
    type        = string
    description = "OpenShift service account dockercfg token"
}

variable "GCP_REGISTRY_TOKEN" {
    type        = string
    description = "GCP service account container registry token"
}

variable "images" {
  type = list(object({
    image         = string
    ocp_tag       = string
    gcp_tag       = optional(string, "")
  }))

  description = "images to maintain"

  default = [
    {
      image         = "tiangolo/uvicorn-gunicorn-fastapi"
      ocp_tag       = ":python3.8"
    },
    {
      image         = "nginx"
      ocp_tag       = ":1.18.0"
    },
    {
      image         = "nats-streaming"
      ocp_tag       = ":0.21.2"
    },
    {
      image         = "node"
      ocp_tag       = ":16.14.2"
    },
    {
      image         = "node"
      ocp_tag       = ":14.15.1"
    },
    {
      image         = "solr"
      ocp_tag       = ":6.6"
    },
    # {
    #   image         = "docker.io/centos/postgresql-12-centos7"
    #   ocp_tag       = "20200917-804ef01"
    # },
    {
      image         = "image-registry.apps.silver.devops.gov.bc.ca/d893f6-tools/minio"
      ocp_tag       = "@sha256:6c7d8bac62177e836f88ef991362a02f5b10faa9cb92aeecd2d3f066042ba849"
      gcp_tag       = ":backup"
    },
    {
      image         = "image-registry.apps.silver.devops.gov.bc.ca/d893f6-tools/nats-streaming"
      ocp_tag       = "@sha256:883d4d7a47db4d1c911cf0c23dad30011b46727297d1158bede3d833455a49e4"
      gcp_tag       = ":backup"
    },
    {
      image         = "image-registry.apps.silver.devops.gov.bc.ca/f2b77c-tools/solr"
      ocp_tag       = "@sha256:4a5cec90c431df6af36f40f73725a9568a6ab7f36fc1a2725abfa8d8ce52e16f"
      gcp_tag       = ":backup"
    },
    {
      image         = "image-registry.apps.silver.devops.gov.bc.ca/f2b77c-tools/namex-solr-base"
      ocp_tag       = "@sha256:1291ad4242474401779f8472314fa42690f0be27534631eea93d41b883fdda7a"
      gcp_tag       = ":backup"
    }
    # {
    #   image         = "image-registry.apps.silver.devops.gov.bc.ca/f2b77c-tools/fdw"
    #   ocp_tag       = "@sha256:956e7855fe743859d47f7efd00e758c8e8947546119716008e839bed2bce51fe"
    #   gcp_tag       = ":backup"
    # }
  ]
}
