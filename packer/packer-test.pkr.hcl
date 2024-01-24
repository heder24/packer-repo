packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "ubuntu" {
  ami_name      = "packer-test-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  profile = "default"
  source_ami_filter {
    filters = {
      name                = "ubuntu/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  ssh_username = "ubuntu"
      tags = {
    Name = "packer-test${local.timestamp}"
    
  }
}

build {
  name    = "packer-test"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

    provisioner "shell" {
        inline =["sudo apt update -y && sudo apt install nginx -y"]
    
  }
}
