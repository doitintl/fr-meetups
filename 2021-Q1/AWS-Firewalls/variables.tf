variable "name" {
  type    = string
  default = "firewall-meetup"
}

variable "tags" {
  default = {
    kind = "demo"
  }
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "instance_type" {
  default = "t2.micro"
}
