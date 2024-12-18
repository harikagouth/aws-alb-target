variable "tags" {
  description = "(Optional) A mapping of tags to assign to the alb target."
  type        = map(string)
  default     = {}
}

variable "context" {
  description = "(Optional) The context that the resource is deployed in. e.g. devops, logs, lake"
  type        = string
  default     = "01"
}

######################## ALB Target Group ########################

variable "port" {
  description = "(Required) Port on which targets receive traffic, unless overridden when registering a specific target. "
  type        = number
  default     = 80
}

variable "protocol" {
  description = "(Required) Protocol to use for routing traffic to the targets. Should be one of HTTP, HTTPS"
  type        = string
  default     = "HTTPS"
}

variable "target_type" {
  description = "(Required) Type of target that you must specify when registering targets with this target group."
  type        = string
  default     = "instance"
}

variable "vpc_id" {
  description = "(Required) Identifier of the VPC in which to create the target group."
  type        = string
}

variable "health_check" {
  description = "(Optional) Health Check configuration block."
  type = list(object({
    enabled             = bool
    healthy_threshold   = number
    interval            = number
    path                = string
    port                = number
    protocol            = string
    timeout             = number
    unhealthy_threshold = number
  }))
}

variable "target_health_state" {
  description = "(Optional) The target health state. The state of the target."
  type = object({
    enable_unhealthy_connection_termination = bool
  })
  default = {
    enable_unhealthy_connection_termination = false
  }

}


######################## ALB Taregt group Attachment #####################

variable "target_id" {
  description = "(Optional) The ID of the target. This is the Instance ID for an instance, or the container ID for an ECS container."
  type        = string
  default     = ""
}