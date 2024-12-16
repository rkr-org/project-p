output "repository_name" {
  description = "ECR repository name"
  value       = aws_ecr_repository.ecr_repository.name
}

output "repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.ecr_repository.repository_url
}

output "repository_arn" {
  description = "ECR repository ARN"
  value       = aws_ecr_repository.ecr_repository.arn
}
