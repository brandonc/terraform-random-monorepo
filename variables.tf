variable "size" {
  type    = number
  default = 2
}

variable "s3_enabled" {
  type    = bool
  default = false
}

variable "local_enabled" {
  type    = bool
  default = true
}

variable "gcs_enabled" {
  type    = bool
  default = false
}

variable "backend_config" {
  type = object({
    bucket     = optional(string)
    key_prefix = optional(string)
    s3 = optional(object({
      provider_region = string
    }))
    gcs = optional(object({
      provider_region = string
    }))
  })

  default = {
    bucket     = "terraform-random-monorepo"
    key_prefix = "state"
  }
}
