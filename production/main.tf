terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.7.4"
}

provider "aws" {
  profile = "default"
  region  = "eu-north-1"
}

variable "production_public_key" {
  description = "Production environment public key value"
  type        = string
}

variable "base_ami_id" {
  description = "Base AMI ID"
  type        = string
}

resource "aws_key_pair" "production_key" {
  key_name   = "production-key"
  public_key = var.production_public_key

  tags = {
    "Name" = "production_public_key"
  }
}

resource "aws_instance" "production_cicd_demo" {
  ami                    = var.base_ami_id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [""]
  key_name               = aws_key_pair.production_key.key_name

  tags = {
    "Name" = "production_cicd_demo"
  }
}

output "production_dns" {
  value = aws_instance.production_cicd_demo.public_dns
}