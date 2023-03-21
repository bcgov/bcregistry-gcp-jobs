variable "environment" {
  type = object({
    project_id     = string
    registry       = string
  })
  description = "GCP project parameters"

  default = {
    project_id      = "c4hnrd-dev"
    registry        = "gcr.io"
  }
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
      image         = "image-registry.apps.silver.devops.gov.bc.ca/d893f6-tools/minio"
      ocp_tag       = "@sha256:6c7d8bac62177e836f88ef991362a02f5b10faa9cb92aeecd2d3f066042ba849"
      gcp_tag       = ":backup"
    }
  ]
}
