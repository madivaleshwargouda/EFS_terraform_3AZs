terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.53.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAWREFFFDHYFH5YRJ6S66"
  secret_key = "8+wjPcuMyl/OiSSGHUKKF::OUHVDGDHUNYCmH"
}

resource "aws_security_group" "efssg" {
  name   = "efssg"
  vpc_id = aws_vpc.efsvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "efsvpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "efsvpc"
  }
}

resource "aws_subnet" "Public-Subnet-1" {
  vpc_id            = aws_vpc.efsvpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "Public-Subnet-1"
  }
}

resource "aws_subnet" "Public-Subnet-2" {
  vpc_id            = aws_vpc.efsvpc.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "Name" = "Public-Subnet-2"
  }
}

resource "aws_subnet" "Public-Subnet-3" {
  vpc_id            = aws_vpc.efsvpc.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    "Name" = "Public-Subnet-3"
  }
}

resource "aws_efs_mount_target" "efs-mt1" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.Public-Subnet-1.id
  security_groups = [aws_security_group.efssg.id]
}

resource "aws_efs_mount_target" "efs-mt2" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.Public-Subnet-2.id
  security_groups = [aws_security_group.efssg.id]
}

resource "aws_efs_mount_target" "efs-mt3" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.Public-Subnet-3.id
  security_groups = [aws_security_group.efssg.id]
}

resource "aws_efs_file_system" "efs" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"
  tags = {
    Name = "Elasticfilesystem"
  }
}
