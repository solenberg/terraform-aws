resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "Solenberg_VPC"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

/*===============
  Public Subnet
===============*/
resource "aws_subnet" "us-east-2a-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Solenberg Public Subnet"
  }
}

resource "aws_route_table" "us-east-2a-public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "us-east-2a-public" {
  subnet_id = "${aws_subnet.us-east-2a-public.id}"
  route_table_id = "${aws_route_table.us-east-2a-public.id}"
}

/*================
  Private Subnet
================*/
resource "aws_subnet" "us-east-2b-private" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.private_subnet_cidr}"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Solenberg Private Subnet"
  }
}

resource "aws_route_table" "us-east-2b-private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags {
    Name = "Private Subnet"
  }
}

resource "aws_route_table_association" "us-east-2b-private" {
  subnet_id = "${aws_subnet.us-east-2b-private.id}"
  route_table_id = "${aws_route_table.us-east-2b-private.id}"
}
