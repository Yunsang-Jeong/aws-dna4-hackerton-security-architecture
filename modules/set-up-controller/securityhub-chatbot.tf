#######################   AWS Chatbot 사전 필수설정   ########################
# AWS Chatbot 콘솔에서 slack workspace에 액세스하기 위한 권한을 허용해야 함
##############################################################################

# 참고: https://github.com/waveaccounting/terraform-aws-chatbot-slack-configuration

module "set_up_securityhub_chatbot" {
  source = "../set-up-securityhub-chatbot"

  service_name = var.service_name

  configuration_name = "chatbot-slack-configuration"
  logging_level      = var.chatbot_logging_level
  slack_channel_id   = var.chatbot_slack_channel_id
  slack_workspace_id = var.chatbot_slack_workspace_id

  # guardrail_policies = [ "arn:aws:iam::aws:policy/ReadOnlyAccess" ]
  # user_role_required = true

  tags = {
    Automation     = "Terraform + Cloudformation"
    Terraform      = true
    Cloudformation = true
  }

  depends_on = [
    aws_securityhub_finding_aggregator.this
  ]
}


