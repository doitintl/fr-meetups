resource "aws_lb" "lb" {
  name               = "alb-${var.name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [aws_subnet.subnet["public_1"].id, aws_subnet.subnet["public_2"].id]

  tags = merge({ Name = "alb-${var.name}" }, var.tags)
}

resource "aws_lb_target_group" "target" {
  name     = "alb-tg-${var.name}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    enabled = true
    path    = "/"
    matcher = "200"
  }

  tags = merge({ Name = "alb-tg-${var.name}" }, var.tags)
}

resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target.arn
  }
}
