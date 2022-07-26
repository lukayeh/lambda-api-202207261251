data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda-lambdarole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  inline_policy {
    name   = "allow_dynamodb"
    policy = file("dynamodbpolicy.json")
  }
}

resource "aws_lambda_function" "http-crud-tutorial-function" {
  function_name    = "http-crud-tutorial-function"
  filename         = "../http-crud-application/http-crud-tutorial-function.zip"
  role             = aws_iam_role.lambda_role.arn
  runtime = "nodejs16.x"
  handler = "index.handler"
  timeout          = 10
}
