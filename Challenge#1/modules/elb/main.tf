## Security Group for ALB
resource "aws_security_group" "alb_sg" {
    name        = "${var.app_name}-lb"
    description = "Load Balancer (ALB) for ${var.app_name}"
    vpc_id      = var.vpc_id
    tags        = var.tags
    ingress {
        #description = "Accept all connections on http"
        from_port = "80"
        to_port = "80"
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

## Create load balancer
resource "aws_alb" "aws_lb" {
  name            = "${var.app_name}-lb-public"
  internal        = false
  idle_timeout    = "300"
  security_groups = [aws_security_group.alb_sg.id]
  subnets         = var.public_subnet_ids
  enable_deletion_protection = false
  tags = var.tags
}

## Connect App to the Application Load Balancer

resource "aws_alb_listener" "HTTP" {
  load_balancer_arn = aws_alb.aws_lb.arn
  port              = "80"
  protocol          = "HTTP"
  tags              = var.tags
  default_action {
    target_group_arn = aws_alb_target_group.aws_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "aws_tg" {
  name        = "${var.app_name}-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  tags        = var.tags
  
  health_check {
    path                = "/status"
    timeout             = 2
    interval            = 5
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }
}

## AWS target group Attachment
resource "aws_lb_target_group_attachment" "http_attachment"{
  count                 = length(var.instance_id)
  target_group_arn      = aws_alb_target_group.aws_tg.arn
  target_id             = var.instance_id[count.index]
  port                  = 8080
}