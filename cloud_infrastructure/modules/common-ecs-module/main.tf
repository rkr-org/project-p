resource "aws_ecs_cluster" "ecs_cluster" {
  name    = "${var.ecs_cluster_name}-${var.environment}"
  setting {
    name  = "containerInsights"
    value = var.container_insights_value
  }
}

resource "aws_cloudwatch_log_resource_policy" "cloudwatch_events_to_log_group_policy" {
  policy_document = data.aws_iam_policy_document.cloudwatch_events_to_log_group_policy_doc.json
  policy_name     = "ecs-cloudwatch-events-to-log-group-${var.environment}"
}

data "aws_iam_policy_document" "cloudwatch_events_to_log_group_policy_doc" {
  statement {
    actions   = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = ["arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:*"]
    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }
}
