module "foo" {
  count = 80
  source = "./random_component"
  templatedir = "${path.module}/templates"
  outputdir = "${path.module}/_generated"
}
