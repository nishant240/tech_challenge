#App
app_name = "challenge1"

#VPC - Configurations
aws_region = "ap-south-1"
aws_zones  = ["ap-south-1a", "ap-south-1b"]
vpc_cidr   = "10.0.0.0/16"

#RDS - Configurations
instance_class        = "db.t3.micro"
allocated_storage     = "20" #GB's
max_allocated_storage = "40" #GB's
engine                = "postgres"
engine_version        = "14.6"

#EC2 - Configurations
instance_count       = 1
instance_type        = "t2.micro"
instance_volume_size = "20" #GB's
private_key_path     = "~/.ssh/id_rsa"
user_data = <<-EOF
    #!/bin/bash
    apt update && apt -y upgrade
    apt install python3-pip postgresql-server-dev-all python3-psycopg2 -y
EOF

#Tags
tags = {
  project_name   = "tech-challenge"
}