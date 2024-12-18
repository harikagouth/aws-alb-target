module "alb-unhealthy_threshold" {
  source      = ".//.."
  target_id   = "arn:aws:elasticloadbalancing:ap-southeast-2:448422491445:loadbalancer/app/alb-rtlh-sbx-ecs-api/82dbb25be1e9a6f3"
  target_type = "alb"
  context     = "tst02"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_health_state = {
    enable_unhealthy_connection_termination = false
  }
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

module "ec2_instance_test-01" {
  source          = "github.com/rio-tinto/rtlh-tf-aws-ec2?ref=v1.2.3"
  context         = "tst"
  image           = var.image
  instance_type   = "t2.medium"
  subnet_ID       = "subnet-09fb13bd6586bfb4e"
  iam_role        = "ec2-iam-rtlh-sbx-devops"
  monitoring      = false
  security_groups = [module.security_group_ec2_test-01.security_group_id]
  volume_size     = var.volume_size
  tags = {
    use-case = "A basic On-Demand EC2 instance with IAM instance profile"
  }
}

module "security_group_ec2_test-01" {
  source            = "github.com/rio-tinto/rtlh-tf-aws-sg?ref=v1.0.1"
  group_description = "RTLH EC2 Instance Test"
  vpc_id            = var.vpc_id

  tags = {
    use-case = "A basic On-Demand EC2 instance with IAM instance profile"
  }

  ingress_rules = [
    {
      description = "Allows inbound HTTP access from any internal address"
      cidr_ipv4   = "10.0.0.0/8"
      from_port   = 80
      to_port     = 80
      ip_protocol = "6"
    },
    {
      description = "Allows inbound SSH access from any internal address"
      cidr_ipv4   = "10.0.0.0/8"
      from_port   = 22
      to_port     = 22
      ip_protocol = "6"
    }
  ]

  egress_rules = [
    {
      description = "Allows all outbound traffic any protocol"
      cidr_ipv4   = "0.0.0.0/0"
      from_port   = "-1" # All ports
      to_port     = "-1" # All ports
      ip_protocol = "-1" # All protocols
    },
    {
      description    = "Allows outbound HTTPS traffic to AWS S3 Gateway"
      prefix_list_id = "pl-6ca54005"
      from_port      = 443
      to_port        = 443
      ip_protocol    = "6"
    }
  ]

}
module "alb-instance" {
  source      = ".//.."
  target_id   = module.ec2_instance_test-01.ec2_id
  target_type = "instance"
  context     = "03"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
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
module "alb-ip" {
  source      = ".//.."
  target_id   = "10.26.6.62"
  target_type = "ip"
  context     = "04"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
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

module "alb-lambda" {
  source      = ".//.."
  target_id   = module.lambda.function_arn
  target_type = "lambda"
  context     = "05"
  protocol    = "TCP"
  vpc_id      = var.vpc_id
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
resource "aws_lambda_permission" "allow_alb_invocation" {
  statement_id  = "AllowALBInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "elasticloadbalancing.amazonaws.com"
  function_name = module.lambda.function_arn  # Assuming this is the Lambda function defined in your module
  source_arn    = module.alb-lambda.alb_target_group_arn  # Reference ALB ARN
}

module "lambda" {

  source = "github.com/rio-tinto/rtlh-tf-aws-lambda?ref=v1.0.0"

  #Required Parameters
  handler = "lambda_function.lambda_handler"
  #s3_key = var.s3_key
  #s3_object_version = var.s3_object_version
  #s3_bucket =  var.s3_bucket                                                                                           #The function entrypoint in your code.
  role = module.iam_role_policy_example.iam_role_arn #IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to.

  #Optional parameters
  create_aws_lambda_function = true         #Controls if Lambda shoulbd be created
  source_code_location       = "local"      #The location of source code. It can be either s3 or local or ecr.
  filename                   = "./test.zip" #Required when "source_code_location" is "local" and need to provide valid value for the attribute .The path to the function's deployment package within the local filesystem. If defined, The s3_-prefixed options cannot be used.

}

module "iam_role_policy_example" {
  source = "github.com/rio-tinto/rtlh-tf-aws-iam?ref=v1.1.1"

  iam_name               = "example-role-name"
  iam_assume_role_policy = file("${path.module}/policy_documents/assume_role_policy.json")

  iam_policy_names = ["example-policy-lambda", "example-policy-s3"]

  iam_role_policies = [
    file("${path.module}/policy_documents/policy_lambda_example.json"),
    file("${path.module}/policy_documents/policy_s3_example.json")
  ]

  create_iam_role   = true # Set to false if you don't want to create the role
  create_iam_policy = true # Set to false if you don't want to create the policies
}