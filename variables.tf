variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default = "us-east-2"
}

variable "amis" {
  description = "AMIs by region"
  default = {
    us-east-2 = "ami-4191b524"
  }
}

variable "vpc_cidr" {
  description = "CIDR for the entire vpc"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default = "10.0.2.0/24"
}
