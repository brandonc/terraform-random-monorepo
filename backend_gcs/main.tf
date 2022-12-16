resource "google_storage_bucket" "gcs_state_storage" {
  name          = var.bucket
  location      = var.region
  force_destroy = true

  public_access_prevention = "enforced"

  versioning {
    enabled = true
  }
}
