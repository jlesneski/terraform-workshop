terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "lucidiaterraform"
    key    = "terraform/lab4/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

#"terraform import aws_instance.import_vm i-0b17e84f25fa8f59f"
#resource "aws_instance" "import_vm" {
#  ami                = "unknown"
#  instance_type      = "unknown"
#}

#resource "aws_instance" "import_vm" {
#  ami                = "ami-097a2df4ac947655f"
#  instance_type      = "t2.micro"
#  tags = {
#    Name = "jamesvm"
#    Imported = "today"
#  }
#}


