provider "aws" {
  region     = "eu-west-1"
}

resource "aws_instance" "web" {
  ami = "ami-1d300869"
  instance_type = "t2.micro"
  tags = {
    Name = "wordpress_instance"
  }
}
