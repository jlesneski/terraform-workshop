locals {
    vpc_cidr = { 
        "DEV"    = "10.101.1.0/24"
        "QA"     = "10.102.1.0/24"
        "PROD"   = "10.100.1.0/24"
    }
    vm_subnet_cidr = { 
        "DEV"    = "10.101.1.64/27"
        "QA"     = "10.102.1.64/27"
        "PROD"   = "10.100.1.64/27"
    }
        vm1_private_ip_addr = { 
        "DEV"    = "10.101.1.70"
        "QA"     = "10.102.1.70"
        "PROD"   = "10.100.1.70"
    }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "lucidiaterraform"
    key    = "terraform/terraform.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}