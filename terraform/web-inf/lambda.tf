# Lambda IAM Role / permissions
resource "aws_iam_role" "datetime" {
  name = "lambda_datetime"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "datetime" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.datetime.name
}

# Generate Lambda with python code package
resource "aws_lambda_function" "datetime" {
  filename         = data.archive_file.lambda_package.output_path
  function_name    = "lambda_datetime"
  role             = aws_iam_role.datetime.arn
  handler          = "lambda.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
}

resource "aws_lambda_permission" "datetime" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.datetime.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.testing.execution_arn}/*/*/*"
}