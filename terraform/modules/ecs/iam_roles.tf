data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_role" {
  name               = "${var.prefix}_ecs_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Required: task execution and autoscaling
resource "aws_iam_role_policy_attachment" "task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "autoscaling_policy" {
  statement {
    effect = "Allow"
    actions = [
      "application-autoscaling:*",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:DeleteAlarms",
      "cloudwatch:DescribeAlarmHistory",
      "cloudwatch:DescribeAlarmsForMetric",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
      "cloudwatch:DisableAlarmActions",
      "cloudwatch:EnableAlarmActions",
      "iam:CreateServiceLinkedRole",
      "sns:CreateTopic",
      "sns:Subscribe",
      "sns:Get*",
      "sns:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "autoscaling_policy" {
  name        = "autoscaling-policy"
  description = "A test policy"
  policy      = data.aws_iam_policy_document.autoscaling_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_autoscaling_policy" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.autoscaling_policy.arn
}
