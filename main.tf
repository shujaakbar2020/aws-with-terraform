provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

resource "aws_vpc" "vpc-8" {
  cidr_block           = "172.168.0.0/24"
  enable_dns_hostnames = true
}

resource "aws_subnet" "pub-subnet-8" {
  vpc_id                  = aws_vpc.vpc-8.id
  availability_zone       = "us-west-1b"
  cidr_block              = "172.168.0.0/24"
  map_public_ip_on_launch = true
}

# resource "aws_subnet" "pvt-subnet-8" {
#   vpc_id            = aws_vpc.vpc-8.id
#   availability_zone = "us-west-1c"
#   cidr_block        = "172.168.20.0/24"
# }

resource "aws_internet_gateway" "ig-8" {
  vpc_id = aws_vpc.vpc-8.id
}

resource "aws_route_table" "rt8" {
  vpc_id = aws_vpc.vpc-8.id
  route {
    gateway_id = aws_internet_gateway.ig-8.id
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "rt8-assoc" {
  subnet_id      = aws_subnet.pub-subnet-8.id
  route_table_id = aws_route_table.rt8.id
}

resource "aws_security_group" "sg8" {
  vpc_id = aws_vpc.vpc-8.id
  ingress {
    from_port   = 0
    to_port     = 65535
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "inst8a" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pub-subnet-8.id
  vpc_security_group_ids = [aws_security_group.sg8.id]
  key_name               = "west"
  user_data              = "${file("jenkins_docker.sh")}"
}

resource "aws_instance" "inst8b" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pub-subnet-8.id
  vpc_security_group_ids = [aws_security_group.sg8.id]
  key_name               = "west"
  user_data              = "${file("docker.sh")}"
}
