backend_config = {
  bucket = "terraform-random-monorepo"
  key_prefix = "state"
  s3 = {
    provider_region = "us-west-2"
  }
  gcs = {
    provider_region = "us-west1"
  }
}

s3_enabled = true
local_enabled = false
gcs_enabled = true
