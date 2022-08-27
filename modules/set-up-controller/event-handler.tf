module "console_login" {
  source = "../event-handler/console-login"

  service_name                = var.service_name
  eventbridge_event_bus_name  = data.aws_cloudwatch_event_bus.default.arn
  eventbridge_event_rule_name = lookup(aws_cloudwatch_event_rule.this, "console-login").name
  eventbridge_event_rule_arn  = lookup(aws_cloudwatch_event_rule.this, "console-login").arn
  event_handler_name          = "console-login"
  event_handler_src_dir       = var.event_handler_src_dir
}

module "create_access_key" {
  source = "../event-handler/create-access-key"

  service_name                = var.service_name
  eventbridge_event_bus_name  = data.aws_cloudwatch_event_bus.default.arn
  eventbridge_event_rule_name = lookup(aws_cloudwatch_event_rule.this, "create-access-key").name
  eventbridge_event_rule_arn  = lookup(aws_cloudwatch_event_rule.this, "create-access-key").arn
  event_handler_name          = "create-access-key"
  event_handler_src_dir       = var.event_handler_src_dir
}

module "sensitive_port_open" {
  source = "../event-handler/sensitive-port-open"

  service_name                = var.service_name
  eventbridge_event_bus_name  = data.aws_cloudwatch_event_bus.default.arn
  eventbridge_event_rule_name = lookup(aws_cloudwatch_event_rule.this, "sensitive-port-open").name
  eventbridge_event_rule_arn  = lookup(aws_cloudwatch_event_rule.this, "sensitive-port-open").arn
  event_handler_name          = "sensitive-port-open"
  event_handler_src_dir       = var.event_handler_src_dir
}

module "detect_login_brute_force" {
  source = "../event-handler/detect-login-brute-force"

  service_name                = var.service_name
  eventbridge_event_bus_name  = data.aws_cloudwatch_event_bus.default.arn
  eventbridge_event_rule_name = lookup(aws_cloudwatch_event_rule.this, "detect-login-brute-force").name
  eventbridge_event_rule_arn  = lookup(aws_cloudwatch_event_rule.this, "detect-login-brute-force").arn
  event_handler_name          = "detect-login-brute-force"
  event_handler_src_dir       = var.event_handler_src_dir
}

module "auto_create_webacl" {
  source = "../event-handler/auto-create-webacl"

  service_name                = var.service_name
  eventbridge_event_bus_name  = data.aws_cloudwatch_event_bus.default.arn
  eventbridge_event_rule_name = lookup(aws_cloudwatch_event_rule.this, "auto-create-webacl").name
  eventbridge_event_rule_arn  = lookup(aws_cloudwatch_event_rule.this, "auto-create-webacl").arn
  event_handler_name          = "auto-create-webacl"
  event_handler_src_dir       = var.event_handler_src_dir
}
