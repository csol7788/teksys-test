resource "aws_api_gateway_rest_api" "testing" {
  name        = "tektest-api"
  description = "API Gateway for a Tech Test"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "testing" {
  rest_api_id = aws_api_gateway_rest_api.testing.id
  parent_id   = aws_api_gateway_rest_api.testing.root_resource_id
  path_part   = "testing"
}

resource "aws_api_gateway_method" "testing" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.testing.id
  rest_api_id   = aws_api_gateway_rest_api.testing.id
}

resource "aws_api_gateway_integration" "testing" {
  rest_api_id             = aws_api_gateway_rest_api.testing.id
  resource_id             = aws_api_gateway_resource.testing.id
  http_method             = aws_api_gateway_method.testing.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.datetime.invoke_arn
}

resource "aws_api_gateway_method_response" "testing" {
  rest_api_id = aws_api_gateway_rest_api.testing.id
  resource_id = aws_api_gateway_resource.testing.id
  http_method = aws_api_gateway_method.testing.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "testing" {
  rest_api_id = aws_api_gateway_rest_api.testing.id
  resource_id = aws_api_gateway_resource.testing.id
  http_method = aws_api_gateway_method.testing.http_method
  status_code = aws_api_gateway_method_response.testing.status_code

  depends_on = [
    aws_api_gateway_method.testing,
    aws_api_gateway_integration.testing
  ]
}

resource "aws_api_gateway_deployment" "testing" {
  rest_api_id = aws_api_gateway_rest_api.testing.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.testing.id,
      aws_api_gateway_method.testing.id,
      aws_api_gateway_integration.testing.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "testing" {
  deployment_id = aws_api_gateway_deployment.testing.id
  rest_api_id   = aws_api_gateway_rest_api.testing.id
  stage_name    = "default"
}

output "invoke_url" {
  value = aws_api_gateway_stage.testing.invoke_url
}

# Restrict Access to a given IP address
#resource "aws_api_gateway_rest_api_policy" "testing" {
#  rest_api_id = aws_api_gateway_rest_api.testing.id
#  policy      = data.aws_iam_policy_document.testing.json
#}