variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
}

variable "container_insights_value" {
  type        = string
  description = "Value for the container insights setting. Value should be 'enabled' or 'disabled'"
  default     = "enabled"
}
