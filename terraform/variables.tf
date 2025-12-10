variable "region" {
type = string
default = "us-east-1"
}


variable "instance_type" {
type = string
default = "t3.micro" # free-tier eligible
}


variable "ssh_public_key" {
type = string
}


variable "allowed_cidr" {
type = string
default = "0.0.0.0/0" # change for security
}


variable "app_port" {
type = number
default = 5000
}
