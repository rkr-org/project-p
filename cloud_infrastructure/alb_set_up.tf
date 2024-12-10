resource "aws_security_group" "alg_sg" {
  name          = "application-load-balancer-security-group-${var.environment}"
  vpc_id        = "vpc-0f25949eae98aa8c8"
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

resource "aws_lb" "app_lb" {
  name               = "test-load-balancer-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alg_sg.id]
  subnets            = ["subnet-07c56a66ac77cacb8", "subnet-03b50fb133b100ac0"]
}

resource "aws_lb_target_group" "app_tg" {
  name        = "app-target-group-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "vpc-0f25949eae98aa8c8"
  target_type = "ip"
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}