variable "name" {
  description ="name of application"
  type = string
  default = "yap"
}

data "aws_vpc" "default" {
  default = true
} 

/* data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["shared-vpc"]
  }
} */

data "aws_subnets" "public" {
  filter{
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name = "tag:Name"
    values = ["public-*"]
  }
}

resource "aws_instance" "public" {
    ami = "ami-04c913012f8977029"
    instance_type = "t2.micro"
    subnet_id = "subnet-004425cdf7e7a28a8"
    #subnet_id = data.aws_subnets.public.ids[1] #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
    associate_public_ip_address = true
    #key_name = "yap-231124" #Change to your keyname, e.g. jazeel-key-pair
    vpc_security_group_ids = [aws_security_group.example.id]

    tags = {
        Name = "${var.name}-dynamodb-reader"
        }
}

resource "aws_security_group" "example" {
    name_prefix = "${var.name}-sg" #Security group name, e.g. jazeel-terraform-security-group
    description = "Security group for EC2"
    vpc_id = data.aws_vpc.default.id #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
    security_group_id = aws_security_group.example.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.example.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 443
    ip_protocol = "tcp"
    to_port = 443
}