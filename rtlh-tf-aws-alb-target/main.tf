resource "aws_lb_target_group" "this" {
  name        = local.name
  port        = var.port
  protocol    = var.protocol
  target_type = var.target_type
  vpc_id      = data.aws_vpc.this.id

  dynamic "health_check" {
    for_each = var.health_check
    content {
      enabled             = health_check.value["enabled"]
      healthy_threshold   = health_check.value["healthy_threshold"]
      interval            = health_check.value["interval"]
      path                = var.protocol == "TCP" ? null : health_check.value["path"]
      port                = health_check.value["port"]
      protocol            = health_check.value["protocol"]
      timeout             = health_check.value["timeout"]
      unhealthy_threshold = health_check.value["unhealthy_threshold"]
    }
  }
  target_health_state {
    enable_unhealthy_connection_termination = var.target_health_state.enable_unhealthy_connection_termination
  }

  tags = var.tags
}

resource "aws_lb_target_group_attachment" "this" {
  #count            = var.target_id != null ? 1 : 0
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_id
}

