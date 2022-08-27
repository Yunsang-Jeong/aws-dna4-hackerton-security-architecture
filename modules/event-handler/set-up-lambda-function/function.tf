data "archive_file" "function" {
  type        = "zip"
  source_dir  = local.source_code_dir
  output_path = "${local.source_code_dir}/function.zip"
  excludes = setunion(
    [
      "function.zip",
      "layer.zip",
    ],
    fileset(local.source_code_dir, "layer/**")
  )

  depends_on = [
    data.archive_file.layer
  ]
}

resource "aws_lambda_function" "this" {
  function_name = "${var.service_name}-${var.event_handler_name}-event-handler"
  role          = aws_iam_role.service_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  timeout       = var.lambda_timeout

  package_type     = "Zip"
  filename         = data.archive_file.function.output_path
  source_code_hash = data.archive_file.function.output_base64sha256
  layers           = flatten(concat(var.lambda_layer_arn_list, [for l in aws_lambda_layer_version.layer : l.arn]))

  dynamic "environment" {
    for_each = var.lambda_environment == null ? [] : ["this"]
    content {
      variables = var.lambda_environment
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_iam_role_policy_attachment.logging,
  ]
}

resource "aws_lambda_permission" "this" {
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  action        = "lambda:InvokeFunction"
  source_arn    = var.eventbridge_event_rule_arn
}

resource "aws_cloudwatch_event_target" "this" {
  event_bus_name = var.eventbridge_event_bus_name
  rule           = var.eventbridge_event_rule_name
  arn            = aws_lambda_function.this.arn
}
