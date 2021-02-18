# Public

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    # https://github.com/hashicorp/terraform-provider-aws/issues/16759
    vpc_endpoint_id = tolist(aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states)[0].attachment[0].endpoint_id
  }

  tags = merge({ Name = "rt-public-${var.name}" }, var.tags)
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.subnet["public_1"].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.subnet["public_2"].id
  route_table_id = aws_route_table.public.id
}

# Private

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw.id
  }

  tags = merge({ Name = "rt-private-${var.name}" }, var.tags)
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.subnet["private"].id
  route_table_id = aws_route_table.private.id
}

# Firewall

resource "aws_route_table" "firewall" {
  vpc_id = aws_vpc.main.id

  # Note that the default route, mapping the VPC's CIDR block to "local",
  # is created implicitly and cannot be specified.

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge({ Name = "rt-firewall-${var.name}" }, var.tags)
}

resource "aws_route_table_association" "firewall" {
  subnet_id      = aws_subnet.subnet["firewall"].id
  route_table_id = aws_route_table.firewall.id
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = aws_subnet.subnet["public_1"].cidr_block
    vpc_endpoint_id = tolist(aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states)[0].attachment[0].endpoint_id
  }
  route {
    cidr_block      = aws_subnet.subnet["public_2"].cidr_block
    vpc_endpoint_id = tolist(aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states)[0].attachment[0].endpoint_id
  }

  tags = merge({ Name = "rt-igw-${var.name}" }, var.tags)
}

resource "aws_route_table_association" "igw" {
  gateway_id     = aws_internet_gateway.gw.id
  route_table_id = aws_route_table.igw.id
}
