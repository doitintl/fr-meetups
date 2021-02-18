resource "aws_launch_template" "webservers" {
  name_prefix   = "template-${var.name}"
  image_id      = data.aws_ami.linux.id
  instance_type = var.instance_type
  placement {
    availability_zone = data.aws_availability_zones.available.names[0]
  }

  network_interfaces {
    security_groups = [aws_security_group.asg.id]
  }

  user_data = filebase64("files/install.sh")

  tag_specifications {
    resource_type = "instance"

    tags = merge({ Name = "webserver-${var.name}" }, var.tags)
  }

  tags = merge({ Name = "template-${var.name}" }, var.tags)
}

resource "aws_autoscaling_group" "webservers" {
  name                = "asg-webservers-${var.name}"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.subnet["private"].id]

  launch_template {
    id      = aws_launch_template.webservers.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.target.id]
}
