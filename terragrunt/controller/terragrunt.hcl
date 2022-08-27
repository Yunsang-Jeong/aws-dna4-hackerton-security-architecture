include "root" {
  path   = find_in_parent_folders("terragrunt.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir("root")}/modules//set-up-controller"
}

inputs = {
  aws_profile_name = "sso-controller"

  organization_member_account_list = [
    # {
    #   member_account_id    = "" 
    #   member_account_email = ""
    # }
  ]

  chatbot_slack_workspace_id = "_NEED_TO_INPUT_"
  chatbot_slack_channel_id   = "_NEED_TO_INPUT_"
}
