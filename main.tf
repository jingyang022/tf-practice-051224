resource "aws_dynamodb_table" "basic-dynamodb-table" {
    name           = "yap-bookinventory"
    billing_mode   = "PAY_PER_REQUEST"
    #read_capacity  = 20
    #write_capacity = 20
    hash_key       = "ISBN"
    range_key      = "Genre"

  attribute {
    name = "ISBN"
    type = "S"
  }

  attribute {
    name = "Genre"
    type = "S"
  }

  attribute {
    name = "Title"
    type = "S"
  }

  attribute {
    name = "Author"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  global_secondary_index {
    name               = "TitleIndex"
    hash_key           = "Title"
    range_key          = "Author"
    #write_capacity     = 10
    #read_capacity      = 10
    projection_type    = "ALL"
    #non_key_attributes = ["UserId"]
  }

  tags = {
    Name        = "yap-inventory"
    Environment = "test"
  }
}

variable "name" {
  description ="name of application"
  type = string
  default = "yap"
}

data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["shared-vpc"]
  }
}

data "aws_subnets" "public" {
  filter{
    name = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name = "tag:Name"
    values = ["public-*"]
  }
}

resource "aws_instance" "public" {
    ami = "ami-04c913012f8977029"
    instance_type = "t2.micro"
    subnet_id = data.aws_subnets.public.ids[0] #Public Subnet ID, e.g. subnet-xxxxxxxxxxx
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
    vpc_id = data.aws_vpc.selected.id #VPC ID (Same VPC as your EC2 subnet above), E.g. vpc-xxxxxxx
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