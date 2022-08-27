#######################   Organization 사전 필수설정   #######################
# 1. Organization > Services > CloudTrail 'Access enabled' 설정
# 2. Organization > Policies > Service control policies 'Enalbed' 설정
##############################################################################

resource "aws_cloudwatch_log_group" "this" {
  name = "${var.service_name}-cw-log-group-cloudtrail"
}

resource "aws_iam_role" "cloud_trail" {
  name = "${var.service_name}-iam-role-cloudtrail"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloud_trail" {
  name = "${var.service_name}-iam-policy-cloudtrail"
  role = aws_iam_role.cloud_trail.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailCreateLogStream2014110",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "AWSCloudTrailPutLogEvents20141101",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF

  depends_on = [
    aws_cloudwatch_log_group.this,
  ]
}

resource "aws_cloudtrail" "this" {
  name                          = "${var.service_name}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.this.id
  s3_key_prefix                 = "prefix" # 로그 파일 전송을 위해 지정한 버킷 이름 뒤에 오는 S3 키 접두사
  include_global_service_events = true
  is_organization_trail         = true
  is_multi_region_trail         = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.this.arn}:*" # CloudTrail requires the Log Stream wildcard
  cloud_watch_logs_role_arn  = aws_iam_role.cloud_trail.arn

  depends_on = [
    aws_iam_role.cloud_trail,
    aws_cloudwatch_log_group.this
  ]
}

resource "aws_cloudtrail_event_data_store" "this" {
  name                           = "${var.service_name}-cloudtrail-event-data-store"
  retention_period               = 7 # number of days of data to retain in your data store (7~2557)
  multi_region_enabled           = true
  organization_enabled           = true # Organization의 Management 계정에서만 실행
  termination_protection_enabled = false

  depends_on = [
    aws_cloudtrail.this
  ]
}
