variable "app_name" {
  type        = string
  description = "Name of the application"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "lb_type" {
  type        = bool
  description = "Type of load balancer internal or external"
}

variable "lb_listener_port" {
  type        = number
  description = "Port of the load balancer listener"
  default     = 443
}

variable "lb_listener_cidr" {
  type        = list(string)
  description = "CIDR blocks of the load balancer listener"
  default     = ["0.0.0.0/0"]
}

variable "tg_port" {
  type        = number
  description = "Port of the target group"
  default     = 80
}

variable "tags" {
  type        = map(string)
  description = "Tags of the load balancer"
  default     = {}
}
