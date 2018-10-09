provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web_service" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "ty"
  user_data     = "${var.user_data}"

  tags {
    Name = "web_service"
  }
}

resource "aws_instance" "Health_check" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name      = "ty"

  tags {
    Name = "Health_check"
  }
}
