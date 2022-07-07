variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}
variable "my_ip_addr" {}

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


resource "aws_security_group" "terra-sg" {
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
}
