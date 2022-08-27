output "controller_event_bus_arn" {
  value = data.aws_cloudwatch_event_bus.default.arn
}

output "controller_event_rule_name_map" {
  value = {
    for k, v in aws_cloudwatch_event_rule.this :
    k => v.name
  }
}

output "controller_event_rule_arn_map" {
  value = {
    for k, v in aws_cloudwatch_event_rule.this :
    k => v.arn
  }
}
