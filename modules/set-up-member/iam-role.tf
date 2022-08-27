#
# aggregator
#
resource "aws_iam_role" "aggregator" {
  name               = "${var.service_name}-aggregator-role"
  assume_role_policy = data.aws_iam_policy_document.event_target_assume_role.json
}

resource "aws_iam_policy" "aggregator_put_event" {
  name   = "${var.service_name}-aggregator-put-event-policy"
  policy = data.aws_iam_policy_document.aggregator_put_event_policy.json
}

resource "aws_iam_role_policy_attachment" "aggregator_put_event" {
  role       = aws_iam_role.aggregator.name
  policy_arn = aws_iam_policy.aggregator_put_event.arn
}

#
# event sender
#
resource "aws_iam_role" "event_sender" {
  name               = "${var.service_name}-event-sender-role"
  assume_role_policy = data.aws_iam_policy_document.event_target_assume_role.json
}

resource "aws_iam_policy" "event_sender_put_event" {
  name   = "${var.service_name}-event-sender-put-event-policy"
  policy = data.aws_iam_policy_document.event_sender_put_event_policy.json
}

resource "aws_iam_role_policy_attachment" "event_sender_put_event" {
  role       = aws_iam_role.event_sender.name
  policy_arn = aws_iam_policy.event_sender_put_event.arn
}

data "aws_iam_policy_document" "event_target_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "aggregator_put_event_policy" {
  statement {
    effect    = "Allow"
    actions   = ["events:PutEvents"]
    resources = [local.aggregator_event_bus_arn]
  }
}

data "aws_iam_policy_document" "event_sender_put_event_policy" {
  statement {
    effect    = "Allow"
    actions   = ["events:PutEvents"]
    resources = [var.controller_event_bus_arn]
  }
}
