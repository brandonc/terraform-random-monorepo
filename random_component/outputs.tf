output "files" {
  value = tolist([
    local_file.main.filename,
    local_file.backend.filename,
  ])
}

output "component_name" {
  value = random_pet.component.id
}

output "backend" {
  value = random_shuffle.backend_type.result[0]
}
