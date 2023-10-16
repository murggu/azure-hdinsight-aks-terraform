locals {
  tags = {
    Owner   = "HDI CAT"
    Toolkit = "Terraform"
  }

  safe_prefix  = replace(var.prefix, "-", "")
  safe_postfix = replace(var.postfix, "-", "")

  basename = "${var.prefix}-${var.postfix}"
}