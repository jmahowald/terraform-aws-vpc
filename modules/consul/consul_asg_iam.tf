

resource "aws_iam_policy" "consul_policy" {
    name = "consul_policy"
    path = "/"
    description = "My test policy"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_iam_role" "consul_role" {
    name = "consul_role"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "consul-attach" {
    role = "${aws_iam_role.consul_role.name}"
    policy_arn = "${aws_iam_policy.consul_policy.arn}"
}

resource "aws_iam_instance_profile" "consul_profile" {
    name = "consul_profile"
    roles = ["${aws_iam_role.consul_role.name}"]
}
