data "aws_vpc" "this" {
  id = var.vpc_id
}

locals {
  workspace = split("-", terraform.workspace)
  name      = format("tg-%s-%s-aws-%s-%s-%s", local.workspace[1], local.workspace[2], local.workspace[4], local.workspace[5], var.context)
}