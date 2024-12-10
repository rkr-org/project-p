variable "ecr_repo_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "image_tag_mutability" {
  type        = string
  description = "Whether to enable tag immutability"
  default     = "IMMUTABLE"
}

variable "scan_on_push" {
  type        = bool
  description = "Whether to enable scanning on push"
  default     = true
}
