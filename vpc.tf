resource "aws_vpc" "vpc_vms" {
  cidr_block = "10.100.1.0/24"
  tags = {
    Name = lower("vpc-vms-${terraform.workspace}")
  }
}