locals {
  tags = {
    provenance  = "terraform"
    region      = var.aws_region
    environment = var.environment
  }
}
