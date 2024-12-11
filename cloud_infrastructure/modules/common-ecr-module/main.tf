resource "aws_ecr_repository" "ecr_repository" {
  name                 = "${var.ecr_repo_name}-${var.environment}"
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  encryption_configuration {
    encryption_type = "KMS"
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_lifecycle_policy" {
  repository = aws_ecr_repository.ecr_repository.name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire images older than 14 days",
        selection    = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 14
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
