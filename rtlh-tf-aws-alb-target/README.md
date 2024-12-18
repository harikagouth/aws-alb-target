<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.23.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.23.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_context"></a> [context](#input\_context) | (Optional) The context that the resource is deployed in. e.g. devops, logs, lake | `string` | `"01"` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | (Optional) Health Check configuration block. | <pre>list(object({<br>    enabled             = bool<br>    healthy_threshold   = number<br>    interval            = number<br>    path                = string<br>    port                = number<br>    protocol            = string<br>    timeout             = number<br>    unhealthy_threshold = number<br>  }))</pre> | n/a | yes |
| <a name="input_port"></a> [port](#input\_port) | (Required) Port on which targets receive traffic, unless overridden when registering a specific target. | `number` | `80` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | (Required) Protocol to use for routing traffic to the targets. Should be one of HTTP, HTTPS | `string` | `"HTTPS"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the alb target. | `map(string)` | `{}` | no |
| <a name="input_target_id"></a> [target\_id](#input\_target\_id) | (Optional) The ID of the target. This is the Instance ID for an instance, or the container ID for an ECS container. | `string` | `""` | no |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | (Required) Type of target that you must specify when registering targets with this target group. | `string` | `"instance"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) Identifier of the VPC in which to create the target group. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_target_group_arn"></a> [alb\_target\_group\_arn](#output\_alb\_target\_group\_arn) | n/a |
| <a name="output_alb_target_group_id"></a> [alb\_target\_group\_id](#output\_alb\_target\_group\_id) | n/a |
| <a name="output_alb_target_group_name"></a> [alb\_target\_group\_name](#output\_alb\_target\_group\_name) | n/a |
<!-- END_TF_DOCS -->