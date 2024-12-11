module "backend_ecr_creation" {
  source        = "./modules/common-ecr-module"
  ecr_repo_name = "backend-repo"
  environment   = var.environment
}

module "backend_ecs_task_definition_creation" {
  source                   = "./modules/common-ecs-task-module"
  ecs_task_definition_name = "backend-ecs-task"
  aws_region               = var.aws_region
  environment              = var.environment
  account_id               = data.aws_caller_identity.this.account_id
  container_name           = "backend-container"
  image_url                = "645708657292.dkr.ecr.ap-south-1.amazonaws.com/vankay:latest"
}

module "backend_lb" {
  source                = "./modules/common-alb-module"
  app_name              = "backend-app"
  vpc_id                = local.vpc_id
  subnet_ids            = local.private_subnets
  environment           = var.environment
  lb_type               = true
  lb_listener_port      = 80
  lb_listener_cidr      = local.private_subnet_cidr_blocks
  tg_port               = 80
  tags                  = {
    "app-name" = "backend-app"
  }
}

resource "aws_ecs_service" "backend_ecs_service" {
  name            = "backend-service-${var.environment}"
  cluster         = module.ecs_creation.ecs_cluster_name
  task_definition = module.backend_ecs_task_definition_creation.task_definition_arn
  desired_count   = 1
  launch_type     = "FARGATE"
  propagate_tags  = "TASK_DEFINITION"

  network_configuration {
    subnets          = local.private_subnets
    security_groups  = [aws_security_group.backend_app_sg.id]
  }

  load_balancer {
    target_group_arn = module.backend_lb.lb_tg_arn
    container_name   = "backend-container-${var.environment}"
    container_port   = 80
  }
  force_new_deployment = true
}

resource "aws_security_group" "backend_app_sg" {
  name          = "backend-app-security-group-${var.environment}"
  vpc_id        = local.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
