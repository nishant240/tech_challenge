## Get the latest ubuntu 22.04 ami id
data "aws_ami" "ubuntu" {
    most_recent = true 
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
    owners = ["099720109477"] # Canonical official
}

## Add current system public key
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.app_name}-ssh-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

## Bastion Security group
resource "aws_security_group" "bastion_sg" {
  name   = "${var.app_name}-bastion_sg"
  vpc_id = var.vpc_id
  tags   = var.tags
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## App_server Security group
resource "aws_security_group" "app_server_sg" {
  name   = "${var.app_name}-app_server_sg"
  vpc_id = var.vpc_id
  tags   = var.tags
  ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "ec2_secrets_manager_instance_profile" {
  name = "ec2-secrets-manager-instance-profile"
  role = var.iam-role
}

##EC2 instance creation
resource "aws_instance" "bastion_host" {
  ami                     = data.aws_ami.ubuntu.id
  availability_zone       = var.aws_zones[0]
  key_name                = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids  = [aws_security_group.bastion_sg.id]
  instance_type           = "t2.micro"
  subnet_id               = var.public_subnet_ids[0]
  tags                    = "${merge(tomap({Name = "${var.app_name}-bastion"}), var.tags)}"
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "10"
    delete_on_termination = true
  }
  # Add current system private key to the bastion host
  user_data = <<-EOF
    #!/bin/bash
    echo "${file(var.private_key_path)}" >> /home/ubuntu/.ssh/id_rsa
    chmod 600 /home/ubuntu/.ssh/id_rsa 
    chown ubuntu:ubuntu /home/ubuntu/.ssh/id_rsa 
  EOF
}

resource "aws_instance" "app_server" {
  ami                     = data.aws_ami.ubuntu.id
  count                   = var.instance_count
  availability_zone       = var.aws_zones[count.index]
  key_name                = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids  = [aws_security_group.app_server_sg.id]
  instance_type           = var.instance_type
  subnet_id               = var.private_subnet_ids[count.index]
  iam_instance_profile    = aws_iam_instance_profile.ec2_secrets_manager_instance_profile.name
  tags                    = "${merge(tomap({Name = "${var.app_name}-app_server-${count.index}"}), var.tags)}"
  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.instance_volume_size
    delete_on_termination = true
  }
  user_data               = base64encode(var.user_data)

  provisioner "file" {
    source      = "${path.module}/db_connection_check.py"
    destination = "db_connection_check.py"

    connection {
    type                = "ssh"
    user                = "ubuntu"
    private_key         = file(var.private_key_path)
    bastion_host        = aws_instance.bastion_host.public_ip
    bastion_user        = "ubuntu"
    bastion_private_key = file(var.private_key_path)
    host                = self.private_ip
   }
  }

}
