resource "aws_security_group" "asg" {
  name        = "asg-sg-${var.name}"
  description = "SG for ASG instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnet["public_1"].cidr_block, aws_subnet.subnet["public_2"].cidr_block]
  }

  ingress {
    description = "Allow established connections"
    from_port  = 1024
    to_port    = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTP(s) traffic"
    from_port  = 80
    to_port    = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow established connections"
    from_port  = 1024
    to_port    = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "asg-sg-${var.name}" }, var.tags)
}

resource "aws_security_group" "alb" {
  name        = "alb-sg-${var.name}"
  description = "SG for ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTP traffic to backend servers"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.subnet["private"].cidr_block]
  }

  tags = merge({ Name = "alb-sg-${var.name}" }, var.tags)
}
