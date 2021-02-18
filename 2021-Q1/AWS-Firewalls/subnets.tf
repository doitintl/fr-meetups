locals {
  subnets = {
    # We need at least 2 subnets in 2 differents AZ to spin up an ALB
    public_1 = {
      cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 0)
      az         = data.aws_availability_zones.available.names[0]
    }
    public_2 = {
      cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 1)
      az         = data.aws_availability_zones.available.names[1]
    }
    private = {
      cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 2)
      # For the sake of simplicity, let's deploy in a single AZ
      az = data.aws_availability_zones.available.names[0]
    }
    firewall = {
      cidr_block = cidrsubnet(var.vpc_cidr_block, 8, 3)
      az         = data.aws_availability_zones.available.names[0]
    }
  }
}

resource "aws_subnet" "subnet" {
  for_each = local.subnets

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value["cidr_block"]
  availability_zone = each.value["az"]

  tags = merge({ Name = "subnet-${each.key}-${var.name}" }, var.tags)
}
