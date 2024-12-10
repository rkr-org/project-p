data "aws_caller_identity" "this" {}

variable "aws_region" {
  type        = string
  default     = "ap-south-1"
  description = "Name of the AWS region"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "ecr_backend_repo_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "ecr_image_tag" {
  type        = string
  default     = "latest"
  description = "Tag of the ECR image for the mutate container"
}
