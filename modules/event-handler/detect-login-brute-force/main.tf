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
  lambda_environment = {
    SLACK_HOOK_URL = "_NEED_TO_INPUT_"
    SLACK_CHANNEL  = "_NEED_TO_INPUT_"
  }
  lambda_log_retention_in_days = 1
  lambda_layer_arn_list        = []
  create_lambda_layer          = false
}
