terraform {
  backend "s3" {
    bucket = "rpa-terraform-bucket"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region     = "eu-west-1"
}

resource "aws_instance" "web" {
  ami = "ami-60349919"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2_instance"
  }
}
