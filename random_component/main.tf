resource "random_pet" "component" {
}

resource "random_integer" "resource_count" {
  min = 1
  max = 5
}

resource "random_shuffle" "backend_type" {
  input = ["s3", "s3", "s3", "s3", "gcs", "azurerm"]
}

resource "local_file" "main" {
  filename = "${var.outputdir}/components/${random_pet.component.id}/main.tf"
  content = templatefile("${var.templatedir}/main.tftpl", { resource_count = random_integer.resource_count.result })
}

resource "local_file" "backend" {
  filename = "${var.outputdir}/components/${random_pet.component.id}/backend.tf"
  content = templatefile(
    "${var.templatedir}/backend.tftpl",
    {
      kind = random_shuffle.backend_type.result[0]
      bucket = "terraform-${random_pet.component.id}-state"
    }
  )
}

output "files" {
  value = tolist([
    local_file.main.filename,
    local_file.backend.filename,
  ])
}
