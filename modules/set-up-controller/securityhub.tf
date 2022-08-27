# Security Hub supports AWS Organizations
resource "aws_securityhub_account" "this" {} # Enable mgmt account's AWS SecurityHub

resource "aws_securityhub_member" "this" { # Add member account (Organization)
  for_each = {
    for account in var.organization_member_account_list :
    account.member_account_id => account
  }

  account_id = each.key
  email      = each.value.member_account_email
  invite     = true

  depends_on = [aws_securityhub_account.this]
}

# Linking all regions
resource "aws_securityhub_finding_aggregator" "this" {
  linking_mode = "ALL_REGIONS"

  depends_on = [aws_securityhub_account.this]
}
