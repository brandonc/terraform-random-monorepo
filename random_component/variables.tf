variable "templatedir" {
  type = string
}

variable "outputdir" {
  type = string
}

variable "possible_backends" {
  type = set(string)

  validation {
    condition = length(setunion(["s3", "local", "gcs"], var.possible_backends)) == 3
    error_message = "possible_backends contains unsupported values"
  }
}

variable "backend_config" {
  type = object({
    bucket     = optional(string)
    key_prefix = optional(string)
    s3         = optional(object({
      provider_region = string
    }))
  })
}
