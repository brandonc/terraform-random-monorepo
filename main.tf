terraform {
  required_providers {
    aws = {
      version = "~> 4.47.0"
    }
    google = {
      version = "~> 4.46.0"
    }
  }
}

module "generate_root_modules" {
  count       = var.size
  source      = "./random_component"
  templatedir = "${path.module}/templates"
  outputdir   = "${path.module}/_generated"
  possible_backends = compact([
    var.s3_enabled ? "s3" : "",
    var.gcs_enabled ? "gcs" : "",
    var.local_enabled ? "local" : "",
  ])
  backend_config = var.backend_config

  depends_on = [
    module.backend_s3,
    module.backend_gcs
  ]
}

module "backend_s3" {
  count  = var.s3_enabled ? 1 : 0
  source = "./backend_s3"
  bucket = var.backend_config.bucket
}

module "backend_gcs" {
  count  = var.gcs_enabled ? 1 : 0
  source = "./backend_gcs"
  bucket = var.backend_config.bucket
  region = var.backend_config.gcs.provider_region
}
