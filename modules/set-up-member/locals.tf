data "aws_caller_identity" "this" {}

data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}

locals {
  account_id               = data.aws_caller_identity.this.account_id
  aggregator_event_bus_arn = data.aws_cloudwatch_event_bus.default.arn
  aggregator_role_arn      = aws_iam_role.aggregator.arn
  controller_account_id    = split(":", var.controller_event_bus_arn)[4]
  event_sender_role_arn    = aws_iam_role.event_sender.arn

  patterns = try(yamldecode(var.patterns_encoded_yaml), {})
}
