backend_config = {
  bucket = "terraform-random-monorepo"
  key_prefix = "state"
  gcs = {
    provider_region = "us-west1"
  }
}

s3_enabled = false
local_enabled = false
gcs_enabled = true
