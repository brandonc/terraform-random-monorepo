module "foo" {
  count = var.size
  source = "./random_component"
  templatedir = "${path.module}/templates"
  outputdir = "${path.module}/_generated"
}
