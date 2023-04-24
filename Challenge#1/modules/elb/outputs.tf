output "alb_arn" {
  description = "ARN of the load balancer"
  value       = aws_alb.aws_lb.arn
}

output "aws_tg" {
  description = "ARN of the target group"
  value       = aws_alb_target_group.aws_tg.arn
}

output "alb_endpoint" {
  description = "ARN of the target group"
  value       = aws_alb.aws_lb.dns_name
}