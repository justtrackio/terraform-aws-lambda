data "aws_iam_policy" "lambda_insights" {
  count = var.insights_enable ? 1 : 0

  name = "CloudWatchLambdaInsightsExecutionRolePolicy"
}
