## Generate Password
resource "random_password" "rds" {
  length           = 24
  special          = true
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  numeric          = true
  override_special = "#!_$%&:<>-=+"
}

## create AWS secret location for rds password
resource "aws_secretsmanager_secret" "rds" {
  name                    = "/${var.app_name}/rds/password"
  description             = "Password for the postgresSQL"
  recovery_window_in_days = 0 
}

## store the password
resource "aws_secretsmanager_secret_version" "rds" {
  secret_id     = aws_secretsmanager_secret.rds.id
  secret_string = random_password.rds.result
  depends_on = [aws_secretsmanager_secret.rds]
}

## create AWS secret location for rds username
resource "aws_secretsmanager_secret" "rds_username" {
  name                    = "/${var.app_name}/rds/username"
  description             = "Username for the postgresSQL"
  recovery_window_in_days = 0 
}

## store the username
resource "aws_secretsmanager_secret_version" "rds_username" {
  secret_id     = aws_secretsmanager_secret.rds_username.id
  secret_string = aws_db_instance.rds_db.username
  depends_on    = [aws_db_instance.rds_db]
}

## create AWS secret location for rds hostname
resource "aws_secretsmanager_secret" "rds_hostname" {
  name                    = "/${var.app_name}/rds/hostname"
  description             = "Hostname for the postgresSQL"
  recovery_window_in_days = 0 
}

## store the hostname
resource "aws_secretsmanager_secret_version" "rds_hostname" {
  secret_id     = aws_secretsmanager_secret.rds_hostname.id
  secret_string = aws_db_instance.rds_db.address
  depends_on    = [aws_db_instance.rds_db]
}