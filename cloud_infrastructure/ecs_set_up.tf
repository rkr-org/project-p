module "ecr_creation" {
  source        = "./modules/common-ecr-module"
  ecr_repo_name = "${var.ecr_backend_repo_name}-${var.environment}"
}

module "ecs_creation" {
  source           = "./modules/common-ecs-module"
  ecs_cluster_name = "${var.ecs_cluster_name}-${var.environment}"
  aws_account_id   = data.aws_caller_identity.this.account_id
  aws_region       = var.aws_region
  environment      = var.environment
}

module "ecs_task_definition_creation" {
  source                   = "./modules/common-ecs-task-module"
  ecs_task_definition_name = "backend-ecs-task-${var.environment}"
  aws_region               = var.aws_region
  environment              = var.environment
  container_name           = "backend-container-${var.environment}"
  image_url                = "${module.ecr_creation.repository_url}:${var.ecr_image_tag}"
}

resource "aws_ecs_service" "backend_service" {
  name            = "backend-service-${var.environment}"
  cluster         = module.ecs_creation.ecs_cluster_name
  task_definition = module.ecs_task_definition_creation.task_definition_arn
  desired_count   = 2
  launch_type     = "FARGATE"
  propagate_tags  = "TASK_DEFINITION"

  network_configuration {
    subnets          = ["subnet-07c56a66ac77cacb8", "subnet-03b50fb133b100ac0"]
    security_groups  = [aws_security_group.backend_app_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "backend-container-${var.environment}"
    container_port   = 80
  }

  force_new_deployment = true
  triggers = {
    redeployment = timestamp()
  }
}

resource "aws_security_group" "backend_app_sg" {
  name          = "backend-app-security-group-${var.environment}"
  vpc_id        = "vpc-0f25949eae98aa8c8"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
