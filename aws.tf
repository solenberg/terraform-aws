provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "/Users/rsolenberg/.aws/credentials"
  profile                 = "default"
}
