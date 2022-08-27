module "function" {
  source = "../set-up-lambda-function"

  service_name                = var.service_name
  eventbridge_event_bus_name  = var.eventbridge_event_bus_name
  eventbridge_event_rule_name = var.eventbridge_event_rule_name
  eventbridge_event_rule_arn  = var.eventbridge_event_rule_arn
  event_handler_src_dir       = var.event_handler_src_dir

  event_handler_name = var.event_handler_name
  lambda_handler     = "lambda_function.lambda_handler"
  lambda_runtime     = "python3.9"
  lambda_timeout     = 180
  lambda_environment = {
    SERVICE_NAME = var.service_name
  }
  lambda_log_retention_in_days = 1
  lambda_layer_arn_list        = []
  create_lambda_layer          = false
}

data "aws_iam_policy_document" "lambda_additional_policy" {
  statement {
    effect = "Allow"
    actions = [
      "waf:*",
      "waf-regional:*",
      "wafv2:*",
      "elasticloadbalancing:SetWebACL",
      "apigateway:SetWebACL",
      "appsync:SetWebACL",
      "logs:DescribeResourcePolicies",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
      "cloudfront:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_additional_policy" {
  name   = "${var.service_name}-iam-policy-lambda-auto-create-webacl"
  policy = data.aws_iam_policy_document.lambda_additional_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_additional_policy" {
  role       = module.function.service_role_name
  policy_arn = aws_iam_policy.lambda_additional_policy.arn
}
