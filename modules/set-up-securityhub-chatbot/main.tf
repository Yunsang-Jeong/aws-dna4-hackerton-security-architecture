data "local_file" "cloudformation_template" {
  filename = "${path.module}/cloudformation.yaml"
}

resource "aws_iam_policy" "iam_policy_chatbot" {
  name        = "${var.service_name}-iam-policy-chatbot"
  path        = "/"
  description = "${var.service_name}-iam-policy-chatbot"
  # policy          = file("/Users/hyerin/Desktop/My_Gitlab/aws-dna-test/modules/case4-securityhub/set-up-alarm/iam-policy/iam-policy-chatbot.json")
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "cloudwatch:Describe*",
          "cloudwatch:Get*",
          "cloudwatch:List*",
          "logs:Get*",
          "logs:List*",
          "logs:Describe*",
          "logs:TestMetricFilter",
          "logs:FilterLogEvents",
          "sns:Get*",
          "sns:List*"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      },
      {
        "Sid" : "AllSlackPermissions",
        "Effect" : "Allow",
        "Action" : [
          "chatbot:Describe*",
          "chatbot:UpdateSlackChannelConfiguration",
          "chatbot:CreateSlackChannelConfiguration",
          "chatbot:DeleteSlackChannelConfiguration",
          "chatbot:CreateChimeWebhookConfiguration",
          "chatbot:UpdateChimeWebhookConfiguration"
        ],
        "Resource" : "arn:aws:chatbot::*:*"
      }
    ]
  })

  tags = {
    Name = "${var.service_name}-iam-policy-chatbot"
  }

  lifecycle {
    ignore_changes = [tags, policy]
  }
}

resource "aws_sns_topic" "sns_topic_chatbot" {
  name = "${var.service_name}-sns-topic-slack"
}

resource "aws_cloudformation_stack" "chatbot_slack_configuration" {
  name = "${var.service_name}-cf-stack-${var.configuration_name}"
  # name = "dna-cf-stack-${var.configuration_name}"

  template_body = data.local_file.cloudformation_template.content

  parameters = {
    ConfigurationNameParameter = var.configuration_name
    GuardrailPoliciesParameter = join(",", var.guardrail_policies)
    # IamRoleArnParameter        = var.iam_role_arn
    IamRoleArnParameter       = aws_iam_policy.iam_policy_chatbot.arn
    LoggingLevelParameter     = var.logging_level
    SlackChannelIdParameter   = var.slack_channel_id
    SlackWorkspaceIdParameter = var.slack_workspace_id
    # SnsTopicArnsParameter      = join(",", var.sns_topic_arns)
    # SnsTopicArnsParameter      = join(",", aws_sns_topic.sns_topic_chatbot.arn)
    SnsTopicArnsParameter     = aws_sns_topic.sns_topic_chatbot.arn
    UserRoleRequiredParameter = var.user_role_required
  }

  tags = var.tags

  depends_on = [
    aws_iam_policy.iam_policy_chatbot,
    aws_sns_topic.sns_topic_chatbot
  ]
}