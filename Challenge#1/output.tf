output "bastion_host_public_ip" {
  value = module.app_server.bastion_ip
}

output "alb_endpoint" {
  description = "ARN of the target group"
  value       = module.alb.alb_endpoint
}