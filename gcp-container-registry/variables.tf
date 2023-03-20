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
  type = list(string)

  description = "images to maintain"

  default = [
    "tiangolo/uvicorn-gunicorn-fastapi:python3.8",
    "nginx:1.18.0",
    "nats-streaming:0.21.2",
    "node:16.14.2",
    "node:14.15.1",
    "minio/minio:RELEASE.2018-07-13T00-09-07Z"
  ]
}
