resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge({ Name = "igw-${var.name}" }, var.tags)
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet["public_1"].id

  tags = merge({ Name = "ngw-${var.name}" }, var.tags)
}

resource "aws_eip" "nat" {
  vpc = true

  tags       = merge({ Name = "eip-nat-${var.name}" }, var.tags)
  depends_on = [aws_internet_gateway.gw]
}
