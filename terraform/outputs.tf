output "base_url" {
  description = "Base URL for API Gateway"
  value       = aws_apigatewayv2_stage.lambdastage.invoke_url
  # api_endpoint - The URI of the API, of the form https://{api-id}.execute-api.{region}.amazonaws.com for HTTP APIs     
}