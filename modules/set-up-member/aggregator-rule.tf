#
# 모든 리전의 default event bus에 패턴 별 룰을 생성합니다.
#

resource "aws_cloudwatch_event_rule" "apne1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apne1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.apne1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "apne2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apne2" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.apne2

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "apne3" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apne3" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.apne3

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "aps1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "aps1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.aps1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "apse1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apse1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.apse1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "apse2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "apse2" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.apse2

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "cac1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "cac1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.cac1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "euc1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "euc1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.euc1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "eun1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "eun1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.eun1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "euw1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "euw1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.euw1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "euw2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "euw2" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.euw2

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "euw3" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "euw3" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.euw3

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "sae1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "sae1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.sae1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "use1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "use1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.use1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "use2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "use2" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.use2

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "usw1" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "usw1" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.usw1

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_event_rule" "usw2" {
  for_each = {
    for alias, pattern in local.patterns :
    alias => pattern
    if "usw2" != var.base_region_alias
  }

  is_enabled     = true
  name_prefix    = "${var.service_name}-${each.key}"
  description    = var.event_rule_description
  event_bus_name = "default"
  event_pattern  = jsonencode(each.value)

  provider = aws.usw2

  lifecycle {
    create_before_destroy = true
  }
}
