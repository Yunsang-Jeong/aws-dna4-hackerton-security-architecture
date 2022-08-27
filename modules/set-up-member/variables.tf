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

variable "controller_event_bus_arn" {
  type = string
}
