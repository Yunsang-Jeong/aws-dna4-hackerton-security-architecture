#
# 각 리전에 생성된 event rule의 target으로 aggregator event bus을 지정합니다.
#

resource "aws_cloudwatch_event_target" "apne1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apne1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.apne1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.apne1
}

resource "aws_cloudwatch_event_target" "apne2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apne2" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.apne2, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.apne2
}

resource "aws_cloudwatch_event_target" "apne3" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apne3" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.apne3, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.apne3
}

resource "aws_cloudwatch_event_target" "aps1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "aps1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.aps1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.aps1
}

resource "aws_cloudwatch_event_target" "apse1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apse1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.apse1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.apse1
}
resource "aws_cloudwatch_event_target" "apse2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apse2" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.apse2, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.apse2
}

resource "aws_cloudwatch_event_target" "cac1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "cac1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.cac1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.cac1
}

resource "aws_cloudwatch_event_target" "euc1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "euc1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.euc1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.euc1
}
resource "aws_cloudwatch_event_target" "eun1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "eun1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.eun1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.eun1
}
resource "aws_cloudwatch_event_target" "euw1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apne3" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.euw1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.euw1
}
resource "aws_cloudwatch_event_target" "euw2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "euw2" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.euw2, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.euw2
}

resource "aws_cloudwatch_event_target" "euw3" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "euw3" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.euw3, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.euw3
}

resource "aws_cloudwatch_event_target" "sae1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "sae1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.sae1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.sae1
}

resource "aws_cloudwatch_event_target" "use1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "use1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.use1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.use1
}

resource "aws_cloudwatch_event_target" "use2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "use2" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.use2, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.use2
}
resource "aws_cloudwatch_event_target" "usw1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "usw1" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.usw1, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.usw1
}

resource "aws_cloudwatch_event_target" "usw2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "usw2" != var.base_region_alias
  }

  rule     = lookup(aws_cloudwatch_event_rule.usw2, each.key).name
  arn      = local.aggregator_event_bus_arn
  role_arn = local.aggregator_role_arn

  provider = aws.usw2
}
