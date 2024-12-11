variable "ecs_task_definition_name" {
  type        = string
  description = "Name of the ECS task"
}

variable "environment" {
  type        = string
  description = "Name of the environment"
}

variable "container_name" {
  type        = string
  description = "Name of the container"
}

variable "image_url" {
  type        = string
  description = "URL of the image present in ECR"
}

variable "aws_region" {
  type        = string
  description = "Region where the resources will be created"
}

variable "account_id" {
  type        = string
  description = "Account ID where the resources will be created"
}

variable "container_port" {
  type        = number
  description = "Port on which the container is running"
  default     = 80
}

variable "host_port" {
  type        = number
  description = "Port on which the host is listening"
  default     = 80
}

variable "aws_logs_stream_prefix" {
  type        = string
  description = "Prefix of the ECS logs stream"
  default     = "ecs"
}

variable "logs_retention_period" {
  type        = number
  description = "Retention period of the ECS logs"
  default     = 14
}

variable "ecs_task_cpu" {
  type        = number
  description = "CPU units"
  default     = 256
}

variable "ecs_task_memory" {
  type        = number
  description = "Memory in MB"
  default     = 512
}

variable "environment_variables" {
  type        = list(map(string))
  description = "Environment variables"
  default     = []
}
