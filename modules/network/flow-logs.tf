
/**
resource "aws_flow_log" "flow_log" {
  log_group_name = "${aws_cloudwatch_log_group.flow_log.name}"
  iam_role_arn = "${aws_iam_role.flow_log.arn}"
  vpc_id = "${aws_vpc.default.id}"
  traffic_type = "ALL"
}

resource "aws_cloudwatch_log_group" "flow_log" {
    name = "flow_log_group"
}

resource "aws_iam_role" "flow_log" {
    name = "flow_log"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
} 
EOF
}

resource "aws_iam_role_policy" "flow_log" {
    name = "flow_log"
    role = "${aws_iam_role.flow_log.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}   
EOF
}
**/