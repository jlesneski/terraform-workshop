resource "aws_vpc" "vpc_vms" {
  cidr_block = local.vpc_cidr[terraform.workspace]
  tags = {
    Name = lower("vpc-vms-${terraform.workspace}")
  }
}

resource "aws_subnet" "vms_subnet" {
  vpc_id            = aws_vpc.vpc_vms.id
  cidr_block        = local.vm_subnet_cidr[terraform.workspace]

  tags = {
    Name = "vms-subnet"
  }
}
