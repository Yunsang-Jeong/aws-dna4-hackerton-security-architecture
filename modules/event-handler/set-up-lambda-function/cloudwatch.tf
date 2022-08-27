resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.service_name}-${var.event_handler_name}-event-handler"
  retention_in_days = var.lambda_log_retention_in_days
}

resource "aws_iam_policy" "logging" {
  name        = "${var.service_name}-${var.event_handler_name}-logging-policy"
  description = "IAM policy for logging from a lambda"
  policy      = data.aws_iam_policy_document.logging.json
}

resource "aws_iam_role_policy_attachment" "logging" {
  role       = aws_iam_role.service_role.name
  policy_arn = aws_iam_policy.logging.arn
}

data "aws_iam_policy_document" "logging" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup"]
    resources = [aws_cloudwatch_log_group.this.arn]
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.this.arn}:*"]
  }
}
