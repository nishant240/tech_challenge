
output "instance_id" {
  description = "List of IDs of instances"
  value       = aws_instance.app_server.*.id
}

output "bastion_ip" {
  value      = aws_instance.bastion_host.public_ip
}