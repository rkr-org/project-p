output "task_definition_arn" {
  description = "The ARN of the created task definition"
  value       = aws_ecs_task_definition.ecs_task_definition.arn
}

output "ecs_task_role_arn" {
  description = "The ARN of the created task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_role_name" {
  description = "The name of the created task role"
  value       = aws_iam_role.ecs_task_role.name
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the created task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_execution_role_name" {
  description = "The name of the created task execution role"
  value       = aws_iam_role.ecs_task_execution_role.name
}
