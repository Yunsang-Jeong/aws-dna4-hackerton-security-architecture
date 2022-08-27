data "aws_caller_identity" "this" {}

data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}

locals {
  patterns = try(yamldecode(var.patterns_encoded_yaml), {})
}
