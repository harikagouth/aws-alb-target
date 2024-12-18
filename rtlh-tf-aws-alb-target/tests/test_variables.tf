# tests/test_variables.tf

variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-2"
}

variable "cost_code" {
  description = "The cost code for the project"
  type        = string
}

variable "requestor" {
  description = "The person requesting the resources"
  type        = string
}

variable "approver" {
  description = "The person approving the resources"
  type        = string
}

variable "sub_domain" {
  description = "The subdomain for the project"
  type        = string
}

variable "application" {
  description = "The application name"
  type        = string
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID to deploy resources in"
  type        = string

}
variable "image" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "volume_size" {
  description = "The size of the EBS volume to attach to the EC2 instance"
  type        = number

}
variable "account_id" {
  description = "The AWS account ID to deploy resources in"
  type        = string
  
}