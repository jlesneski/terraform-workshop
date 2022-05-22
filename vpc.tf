resource "aws_vpc" "vpc_vms" {
  cidr_block = "10.100.1.0/24"
  tags = {
    Name = lower("vpc-vms-${terraform.workspace}")
  }
}

resource "aws_subnet" "vms_subnet" {
  vpc_id            = aws_vpc.vpc_vms.id
  cidr_block        = "10.100.1.64/27"

  tags = {
    Name = "vms-subnet"
  }
}