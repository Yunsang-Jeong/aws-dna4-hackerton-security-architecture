include "root" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules//set-up-member"
}

dependency "controller" {
  config_path = "../../controller"
}

inputs = {
  aws_profile_name = "sso-member4"

  controller_event_bus_arn = dependency.controller.outputs.controller_event_bus_arn
}
