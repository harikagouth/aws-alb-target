output "alb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "alb_target_group_name" {
  value = aws_lb_target_group.this.name
}

output "alb_target_group_id" {
  value = aws_lb_target_group.this.id
}