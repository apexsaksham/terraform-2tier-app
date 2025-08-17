resource "aws_lb" "application_load_balancer" {
  name                       = "tf-2tier-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg_id] # Make sure root passes alb_sg_id as string
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false

  tags = {
    Name = "tf-2tier-alb"
  }
}

resource "aws_lb_target_group" "voting_target_group" {
  name     = "voting-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id # ✅ fixed: use the VPC ID passed into the module

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = "/health"
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = {
    Name = "tf-voting-target-group"
  }
}

resource "aws_lb_target_group_attachment" "voting_target_attachment" {
  target_group_arn = aws_lb_target_group.voting_target_group.arn
  target_id        = var.backend_instance_id # ✅ make this an input variable
  port             = var.target_port
}

resource "aws_lb_listener" "voting_alb_listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.voting_target_group.arn
  }
}
