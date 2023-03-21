resource "aws_flow_log" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  iam_role_arn    = aws_iam_role.flow_logs.arn
  log_destination = aws_cloudwatch_log_group.flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.current.id
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name   = "${var.name_prefix}-vpc-flow-logs"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name   = "${var.name_prefix}-vpc-flow-logs"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "flow_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = [aws_cloudwatch_log_group.flow_logs.arn]
  }
}

resource "aws_iam_policy" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name   = "${var.name_prefix}-vpc-flow-logs"
  policy = data.aws_iam_policy_document.flow_logs.json
}

resource "aws_iam_role_policy_attachment" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  role       = aws_iam_role.flow_logs.name
  policy_arn = aws_iam_policy.flow_logs.arn
}