resource "aws_ecs_task_definition" "ecs_task_definition" {
  family       = var.ecs_task_definition_name
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_url
      essential = true
      portMappings = [
        {
          name          = "${var.host_port}-tcp"
          containerPort = var.container_port
          hostPort      = var.host_port
          protocol      = "tcp"
          appProtocol   = "http"
        }
      ]
      # logConfiguration = {
      #   logDriver = "awslogs"
      #   options = {
      #     awslogs-group = "/ecs/${var.container_name}"
      #     awslogs-region = var.aws_region
      #     awslogs-stream-prefix = var.aws_logs_stream_prefix
      #   }
      # }
    }
  ])
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.ecs_task_definition_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.ecs_task_definition_name}-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
