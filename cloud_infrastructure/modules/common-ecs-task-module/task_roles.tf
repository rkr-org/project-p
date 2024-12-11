data "aws_iam_policy_document" "ecs_task_assume_policy" {
  statement {
    sid     = "ECSTaskAssumePrinciple"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.ecs_task_definition_name}-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_task_cloudwatch_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.ecs_task_definition_name}-execution-role-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_policy.json
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_additional_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_role_policy.arn
}

resource "aws_iam_policy" "ecs_task_execution_role_policy" {
  name   = "${var.ecs_task_definition_name}-execution-role-policy-${var.environment}"
  policy = data.aws_iam_policy_document.cloudwatch_access_policy.json
}

data "aws_iam_policy_document" "cloudwatch_access_policy" {
  statement {
    sid    = "CloudWatchAccess"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/ecs/*"]
  }
}
