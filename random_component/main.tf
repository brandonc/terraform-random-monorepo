# The random name of the component
resource "random_pet" "component" {
}

# A null resource that triggers a rm on the generated component directory
resource "null_resource" "deleter" {
  triggers = {
    deleteme = "${var.outputdir}/components/${random_pet.component.id}"
  }

  provisioner "local-exec" {
    when = destroy
    command = "rm -rf ${self.triggers.deleteme}"
  }
}

# The number of resources to create.
resource "random_integer" "resource_count" {
  min = 1
  max = 1
}

# The random backend chosen among enabled backends
resource "random_shuffle" "backend_type" {
  input = var.possible_backends
  result_count = 1
}

# Generates main.tf from template
resource "local_file" "main" {
  filename = "${var.outputdir}/components/${random_pet.component.id}/main.tf"
  content = templatefile("${var.templatedir}/main.tftpl", { resource_count = random_integer.resource_count.result })

  provisioner "local-exec" {
    command = "terraform -chdir=\"${var.outputdir}/components/${random_pet.component.id}\" init"
  }

  provisioner "local-exec" {
    command = "terraform -chdir=\"${var.outputdir}/components/${random_pet.component.id}\" apply --auto-approve"
  }

  depends_on = [
    # Must exist before provisioners are run
    local_file.backend
  ]
}

locals {
  configured_backend = random_shuffle.backend_type.result[0]

  default_opts = {
    bucket          = var.backend_config.bucket
    key             = "${var.backend_config.key_prefix}-${random_pet.component.id}"
  }
}

// Generates backend.tf from template
resource "local_file" "backend" {
  filename = "${var.outputdir}/components/${random_pet.component.id}/backend.tf"
  content = templatefile(
    "${var.templatedir}/backends/${local.configured_backend}.tftpl",
    {
      options = merge(
        contains(keys(var.backend_config), local.configured_backend) ? var.backend_config[local.configured_backend] : {},
        local.default_opts
      )
    }
  )

  lifecycle {
    precondition {
      condition = (local.configured_backend == "local" || local.configured_backend == "gcs" || (local.configured_backend == "s3" && var.backend_config.s3 != null))
      error_message = "the backend_config for ${local.configured_backend} requires a backend-specific key"
    }
  }
}
