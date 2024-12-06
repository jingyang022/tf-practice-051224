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