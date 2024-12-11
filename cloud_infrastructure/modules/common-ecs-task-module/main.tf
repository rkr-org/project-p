resource "aws_cloudwatch_log_group" "container_log_group" {
  name              = "/ecs/${var.container_name}-${var.environment}"
  retention_in_days = var.logs_retention_period
  skip_destroy      = false
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  depends_on               = [aws_cloudwatch_log_group.container_log_group]
  family                   = "${var.ecs_task_definition_name}-${var.environment}"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  container_definitions    = jsonencode([
    {
      name         = "${var.container_name}-${var.environment}"
      image        = var.image_url
      essential    = true
      environment  = var.environment_variables
      portMappings = [
        {
          name          = "${var.host_port}-tcp"
          containerPort = var.container_port
          hostPort      = var.host_port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.container_name}-${var.environment}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.aws_logs_stream_prefix
        }
      }
    }
  ])
}
