# Generate Lambda Code Package
data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/../../lambda_code/lambda.py"
  output_path = "${path.module}/../../lambda_packages/lambda.zip"
}

# IP restriction policy for the API Gateway to secure it
#data "aws_iam_policy_document" "testing" {
#  statement {
#    effect = "Deny"
#
#    principals {
#      type        = "*"
#      identifiers = ["*"]
#    }
#
#    actions   = ["execute-api:Invoke"]
#    resources = ["${aws_api_gateway_rest_api.testing.execution_arn}/*/*/*"]
#
#    condition {
#      test     = "NotIpAddress"
#      variable = "aws:SourceIp"
#      values   = ["12.34.56.78/32"] 
#    }
#  }
#  statement {
#    effect = "Allow"
#
#    principals {
#      type        = "*"
#      identifiers = ["*"]
#    }
#
#    actions   = ["execute-api:Invoke"]
#    resources = ["${aws_api_gateway_rest_api.testing.execution_arn}/*/*/*"]
#  }
#}