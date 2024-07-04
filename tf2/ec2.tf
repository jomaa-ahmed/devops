provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "demo-server" {
  ami             = "ami-053b0d53c279acc90"
  instance_type   = "t2.micro"
  key_name        = "ec2"
  //security_groups = ["demo-sg"]
  vpc_security_group_ids = [aws_security_group.demo-sg.id]
  subnet_id       = aws_subnet.dpp-public-subnet-01.id
  for_each = toset(["Jenkins-master", "Build-slave","ansible"])
   tags = {
     Name = "${each.key}"
   }
}

resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH access"
  vpc_id      = aws_vpc.dpp_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ssh-prot"

  }
}

//creating a vpc
resource "aws_vpc" "dpp_vpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    name = "dpp_vpc"
  }
}


//creating a public subnet
//cause we want to launch a public instance {map_public_ip_on_launch = "true"}
resource "aws_subnet" "dpp-public-subnet-01" {
  vpc_id                  = aws_vpc.dpp_vpc.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "dpp-public-subnet-01"
  }

}

//creating a public subnet 2 
resource "aws_subnet" "dpp-public-subnet-02" {
  vpc_id                  = aws_vpc.dpp_vpc.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "dpp-public-subnet-02"
  }

}

// create IGW to connect to the internet
resource "aws_internet_gateway" "dpp_igw" {
  vpc_id = aws_vpc.dpp_vpc.id
  tags = {
    Name = "dpp_igw"
  }
}


//creating a route table
resource "aws_route_table" "dpp-public-rt" {
  vpc_id = aws_vpc.dpp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpp_igw.id
  }

}


//associating the route table with the public subnet
resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
  subnet_id      = aws_subnet.dpp-public-subnet-01.id
  route_table_id = aws_route_table.dpp-public-rt.id
}

//associating the route table with the public subnet 2
resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
  subnet_id      = aws_subnet.dpp-public-subnet-02.id
  route_table_id = aws_route_table.dpp-public-rt.id
}
