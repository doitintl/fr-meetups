resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = merge({ Name = "vpc-${var.name}" }, var.tags)
}
