output "lb_name" {
  description = "Name of the load balancer"
  value       = aws_lb.app_lb.name
}

output "lb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.app_lb.arn
}

output "lb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.app_lb.dns_name
}

output "lb_tg_arn" {
  description = "ARN of the load balancer target group"
  value       = aws_lb_target_group.app_lb_tg.arn
}

output "lb_sg_id" {
  description = "ID of the load balancer security group"
  value       = aws_security_group.app_lb_sg.id
}
