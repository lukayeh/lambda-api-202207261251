resource "aws_apigatewayv2_api" "lambdagateway" {
  name          = "http-crud-tutorial-api"
  description   = "HTTP API Malware Check Gateway"
  protocol_type = "HTTP"
  # api_endpoint - The URI of the API, of the form https://{api-id}.execute-api.{region}.amazonaws.com for HTTP APIs     
}

resource "aws_apigatewayv2_stage" "lambdastage" {
  api_id      = aws_apigatewayv2_api.lambdagateway.id
  name        = "$default"
  auto_deploy = true
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format = jsonencode({
      "requestId" : "$context.requestId",
      "extendedRequestId" : "$context.extendedRequestId",
      "ip" : "$context.identity.sourceIp",
      "caller" : "$context.identity.caller",
      "user" : "$context.identity.user",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "resourcePath" : "$context.resourcePath",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength",
      "integrationErrorMessage" : "$context.integrationErrorMessage",
      "errorMessage" : "$context.error.message",
      "errorResponseType" : "$context.error.responseType"
    })
  }
}

resource "aws_apigatewayv2_integration" "lambda_get_integration" {
  description = "HTTP Integration HTTP GET to Lambda"  
  api_id               = aws_apigatewayv2_api.lambdagateway.id
  integration_type     = "AWS_PROXY"
  integration_method   = "POST"
  integration_uri      = aws_lambda_function.http-crud-tutorial-function.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "lambda_get_route" {
  api_id    = aws_apigatewayv2_api.lambdagateway.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_get_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_get_id_route" {
  api_id    = aws_apigatewayv2_api.lambdagateway.id
  route_key = "GET /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_get_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_put_route" {
  api_id    = aws_apigatewayv2_api.lambdagateway.id
  route_key = "PUT /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_get_integration.id}"
}

resource "aws_apigatewayv2_route" "lambda_delete_route" {
  api_id    = aws_apigatewayv2_api.lambdagateway.id
  route_key = "DELETE /items/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_get_integration.id}"
}

resource "aws_lambda_permission" "api_gw_items" {  
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http-crud-tutorial-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambdagateway.execution_arn}/*/*/items"
}


resource "aws_lambda_permission" "api_gw_items_id" {  
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.http-crud-tutorial-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.lambdagateway.execution_arn}/*/*/items/{id}"
}