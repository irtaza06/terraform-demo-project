variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip_addr" {}
variable "instance_type" {}
variable "public_key_location" {}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_vpc" "terra-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
        Name = "${var.env_prefix}-vpc"
          }
}

resource "aws_subnet" "terra-subnet-1" {
  vpc_id     = aws_vpc.terra-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
        Name = "${var.env_prefix}-subnet-1"
          }
}


/*resource "aws_route_table" "terra-rtb" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }
  tags = {
        Name = "${var.env_prefix}-rtb"
          }
}*/


resource "aws_default_route_table" "terra-main-trb" {
  default_route_table_id = aws_vpc.terra-vpc.default_route_table_id 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }
  tags = {
        Name = "${var.env_prefix}-main-rtb"
          }
}

resource "aws_internet_gateway" "terra-igw" {
 vpc_id = aws_vpc.terra-vpc.id
  tags = {
        Name = "${var.env_prefix}-igw"
          }
}



resource "aws_route_table_association" "as-rtb-subnet1" {
  subnet_id = aws_subnet.terra-subnet-1.id
  route_table_id = aws_vpc.terra-vpc.default_route_table_id 
}


/*resource "aws_security_group" "terra-sg" {
  name =  "terra-sg"
  vpc_id = aws_vpc.terra-vpc.id
  ingress {
    from_port = 22 
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip_addr]
  }
   ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
        Name = "${var.env_prefix}-sg"
          }
}*/


resource "aws_default_security_group" "terra-default-sg" {
  vpc_id = aws_vpc.terra-vpc.id
  ingress {
    from_port = 22 
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.my_ip_addr]
  }
   ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
        Name = "${var.env_prefix}-default-sg"
          }
}

data "aws_ami" "latest-amazon-ami" {
      most_recent = true
      owners = ["amazon"]
       filter {
         name   = "name"
         values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
      }
       filter {
         name   = "root-device-type"
         values = ["ebs"]
      }
       filter {
         name   = "virtualization-type"
         values = ["hvm"]
      }

}


output "AMI-ID" {
  value = data.aws_ami.latest-amazon-ami.id
}

output "Instance-PublicIp" {
  value = aws_instance.terra-instance.public_ip
}


resource "aws_key_pair" "terra-ssh-key" {
  key_name = "terra-aws-FF"
  public_key = "${file(var.public_key_location)}"
}

resource "aws_instance" "terra-instance" {
  ami = data.aws_ami.latest-amazon-ami.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.terra-subnet-1.id
  vpc_security_group_ids = [aws_default_security_group.terra-default-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.terra-ssh-key.key_name
  tags = {
        Name = "${var.env_prefix}-server"
          }


}
