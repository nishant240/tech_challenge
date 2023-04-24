resource "aws_db_subnet_group" "rds_subnet" {
  name       = "${var.app_name}-rds_subnet"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "rds_sg" {
  name   = "${var.app_name}-rds_sg"
  vpc_id = var.vpc_id
  tags   = var.tags
  ingress {
      from_port   = 5432
      to_port     = 5432
      protocol    = "TCP"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds_db" {
  identifier             = "${var.app_name}-db"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  username               = var.app_name
  password               = data.aws_secretsmanager_secret_version.rds.secret_string
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags = var.tags
}