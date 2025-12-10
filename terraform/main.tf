terraform {


resource "aws_security_group" "app_sg" {
name = "mini-devops-sg"
description = "Allow HTTP and SSH"


ingress {
description = "app port"
from_port = var.app_port
to_port = var.app_port
protocol = "tcp"
cidr_blocks = [var.allowed_cidr]
}


ingress {
description = "ssh"
from_port = 22
to_port = 22
protocol = "tcp"
cidr_blocks = [var.allowed_cidr]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}


resource "aws_instance" "app" {
ami = data.aws_ami.ubuntu.id
instance_type = var.instance_type
key_name = aws_key_pair.deployer.key_name
vpc_security_group_ids = [aws_security_group.app_sg.id]


user_data = file("user_data.sh")


tags = {
Name = "mini-devops-app"
}
}


data "aws_ami" "ubuntu" {
most_recent = true
owners = ["099720109477"] # Ubuntu


filter {
name = "name"
values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
}
}


output "public_ip" {
value = aws_instance.app.public_ip
}


output "public_dns" {
value = aws_instance.app.public_dns
}
