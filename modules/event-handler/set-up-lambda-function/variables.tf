variable "service_name" {
  type = string
}

variable "eventbridge_event_bus_name" {
  type = string
}

variable "eventbridge_event_rule_arn" {
  type = string
}

variable "eventbridge_event_rule_name" {
  type = string
}

variable "event_handler_src_dir" {
  type = string
}

variable "event_handler_name" {
  type = string
}

variable "lambda_handler" {
  type = string
}

variable "lambda_runtime" {
  type = string
}

variable "lambda_environment" {
  type    = map(string)
  default = null
}

variable "lambda_log_retention_in_days" {
  type    = number
  default = 1
}

variable "create_lambda_layer" {
  type    = bool
  default = false
}

variable "packaged_lambda_layer_file_name" {
  type    = string
  default = "layer.zip"
}

variable "lambda_layer_arn_list" {
  type    = list(string)
  default = []
}

variable "lambda_timeout" {
  type    = number
  default = 10
}
