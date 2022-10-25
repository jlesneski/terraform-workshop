terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "lucidiaterraform"
    key    = "terraform/lab1/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

data "aws_ami" "ubuntu_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_vpc" "vpc_lab1_vms" {
  cidr_block = "10.201.99.0/24"
  tags = {
    Name = "vpc-lab1-vms"
  }
}

resource "aws_subnet" "vms_lab1_subnet" {
  vpc_id            = aws_vpc.vpc_lab1_vms.id
  cidr_block        = "10.201.99.64/27"
  tags = {
    Name = "vms-lab1-subnet"
  }
}

resource "aws_network_interface" "vm1_lab1_nic1" {
  subnet_id   = aws_subnet.vms_lab1_subnet.id
  private_ips = ["10.201.99.70"]

  tags = {
    Name = "vm1-lab1-nic1"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu_latest.id
  instance_type = "t3.micro"

  network_interface {
    network_interface_id = aws_network_interface.vm1_lab1_nic1.id
    device_index         = 0
  }
  tags = {
    Name = "vm1-lab1-web1"
  }
}
