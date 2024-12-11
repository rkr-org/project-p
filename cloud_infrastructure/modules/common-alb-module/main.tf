resource "aws_lb" "app_lb" {
  name               = "${var.app_name}-load-balancer-${var.environment}"
  internal           = var.lb_type
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_lb_sg.id]
  subnets            = var.subnet_ids
  tags               = var.tags
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = var.lb_listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_lb_tg.arn
  }
  lifecycle {
    create_before_destroy = true
  }
  tags              = var.tags
}

resource "aws_security_group" "app_lb_sg" {
  name          = "${var.app_name}-load-balancer-allow-http-${var.environment}"
  vpc_id        = var.vpc_id

  ingress {
    from_port   = var.lb_listener_port
    to_port     = var.lb_listener_port
    protocol    = "tcp"
    cidr_blocks = var.lb_listener_cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags          = var.tags
}

resource "aws_lb_target_group" "app_lb_tg" {
  name_prefix      = var.environment
  port             = var.tg_port
  protocol         = "HTTP"
  vpc_id           = var.vpc_id
  target_type      = "ip"
  lifecycle {
    create_before_destroy = true
  }
  tags             = var.tags
}
