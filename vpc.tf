resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags {
    Name = "MyVPC"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

/*==============
  Nat Instance
===============*/

resource "aws_security_group" "nat_testing" {
  name = "vpc_nat"
  description = "Allow traffic to pass from private sub to internet"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }
  egress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "natSG"
  }
}

resource "aws_instance" "nat_testing" {
  ami = "ami-07fdd962"
  availability_zone = "us-east-2a"
  instance_type = "t2.micro"
  key_name = "${var.aws_key_name}"
  vpc_security_group_ids = ["${aws_security_group.nat_testing.id}"]
  subnet_id = "${aws_subnet.us-east-2a-public.id}"
  associate_public_ip_address = true
  source_dest_check = false

  tags {
    Name = "VPC nat"
  }
}

resource "aws_eip" "nat_testing" {
  instance = "${aws_instance.nat_testing.id}"
  vpc = true
}

/*===============
  Public Subnet
===============*/
resource "aws_subnet" "us-east-2a-public" {
  vpc_id = "${aws_vpc.default.id}"

  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Public Subnet"
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
    Name = "Private Subnet"
  }
}

resource "aws_route_table" "us-east-2b-private" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat_testing.id}"
  }

  tags {
    Name = "Private Subnet"
  }
}

resource "aws_route_table_association" "us-east-2b-private" {
  subnet_id = "${aws_subnet.us-east-2b-private.id}"
  route_table_id = "${aws_route_table.us-east-2b-private.id}"
}
