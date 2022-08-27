#
# base region의 default event bus에 모인 event를 controller로 보냅니다.
#

resource "aws_cloudwatch_event_rule" "base" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if local.controller_account_id != local.account_id
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_target" "base" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if local.controller_account_id != local.account_id
  }

  rule     = lookup(aws_cloudwatch_event_rule.base, each.key).name
  arn      = var.controller_event_bus_arn
  role_arn = local.event_sender_role_arn
}
