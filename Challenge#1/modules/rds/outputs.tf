## retrieve password
data "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  depends_on = [aws_secretsmanager_secret_version.rds]
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.rds_db.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.rds_db.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance username"
  value       = aws_db_instance.rds_db.username
  sensitive   = true
}