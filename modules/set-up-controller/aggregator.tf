#
# default event bus에 패턴 별 룰을 생성합니다. 타겟은 event-handler에서 생성합니다.
#

data "aws_organizations_organization" "this" {}

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "OrganizationAccess"
    effect = "Allow"
    actions = [
      "events:PutEvents"
    ]
    resources = [
      data.aws_cloudwatch_event_bus.default.arn
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.this.id]
    }
  }
}

resource "aws_cloudwatch_event_bus_policy" "this" {
  policy         = data.aws_iam_policy_document.this.json
  event_bus_name = "default"
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  lifecycle {
    create_before_destroy = true
  }
}
