variable "service_name" {
  type = string
}

variable "base_region" {
  type = string
}

variable "base_region_alias" {
  type = string
}

variable "aws_profile_name" {
  type = string
}

variable "event_rule_description" {
  type    = string
  default = "This rule is managed by terraform"
}

variable "patterns_encoded_yaml" {
  type    = string
  default = ""
}

variable "event_handler_src_dir" {
  type = string
}

variable "lambda_log_retention_in_days" {
  type    = number
  default = 1
}

variable "organization_member_account_list" {
  type = list(map(string))
}

variable "chatbot_logging_level" {
  type = string
  description = "ERROR | INFO | NONE"
  default = "ERROR"
}

variable "chatbot_slack_workspace_id" {
  type = string
}

variable "chatbot_slack_channel_id" {
  type = string
}
