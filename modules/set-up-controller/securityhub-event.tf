resource "aws_cloudwatch_event_rule" "eb_securityhub_imported" {
  name        = "${var.service_name}-eventbridge-securityhub-alarm-imported"
  description = "for SecurityHub Alarm"

  event_pattern = <<-EOF
    {
      "source": ["aws.securityhub"],
      "detail-type": ["Security Hub Findings - Imported"]
    }
  EOF
}

resource "aws_cloudwatch_event_rule" "eb_securityhub_cloudtrail_api" {
  name        = "${var.service_name}-eventbridge-securityhub-alarm-trail"
  description = "for SecurityHub Alarm"

  event_pattern = <<-EOF
    {
      "source": ["aws.securityhub"],
      "detail-type": ["AWS API Call via CloudTrail"],
      "detail": {
        "eventSource": ["securityhub.amazonaws.com"]
      }
    }
  EOF
}

resource "aws_cloudwatch_event_target" "eb_securityhub_imported" {
  rule = aws_cloudwatch_event_rule.eb_securityhub_imported.name
  arn  = module.set_up_securityhub_chatbot.sns_topic_arn
}

resource "aws_cloudwatch_event_target" "eb_securityhub_cloudtrail_api" {
  rule = aws_cloudwatch_event_rule.eb_securityhub_cloudtrail_api.name
  arn  = module.set_up_securityhub_chatbot.sns_topic_arn
}