# Module for creating DynamoDB
# https://registry.terraform.io/modules/terraform-aws-modules/dynamodb-table/aws/latest

module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = "http-crud-tutorial-items"
  hash_key = "id"

  billing_mode   = "PROVISIONED"
  read_capacity  = 10
  write_capacity = 10

  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]


  tags = {
    Terraform   = "true"
    Environment = var.aws_environment
  }
}
