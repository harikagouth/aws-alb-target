terraform {
  required_version = ">=1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.23.1"
    }
  }
}

module "alb" {
  source = "github.com/rio-tinto/rtlh-tf-aws-alb?ref=v0.0.6"

  subnet_ids                 = [data.aws_subnet.this.id, data.aws_subnet.sn02.id]
  enable_deletion_protection = false
  security_group_ids         = [data.aws_security_group.this.id]
  access_logs = [{
    bucket  = ""
    enabled = false
    folder  = ""
  }]
  connection_logs = [{
    bucket  = ""
    enabled = false
    folder  = ""
  }]
}

module "alb-tg" {
  source      = "github.com/rio-tinto/rtlh-tf-aws-alb-target?ref=v0.0.4"
  target_id   = data.aws_alb.this.id
  target_type = "alb"
  context     = "deleteme"
  port        = 80
  protocol    = "TCP"
  vpc_id      = data.aws_subnet.this.vpc_id
  health_check = [{
    enabled             = true
    path                = "/status"
    healthy_threshold   = 3
    interval            = 60
    port                = 80
    protocol            = "HTTP"
    unhealthy_threshold = 3
    timeout             = 30
  }]
}