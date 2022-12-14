module "foo" {
  count = 40
  source = "./random_component"
  templatedir = "${path.module}/templates"
  outputdir = "${path.module}/_generated"
}
