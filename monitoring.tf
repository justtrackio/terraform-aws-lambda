locals {
  alarm_description = jsonencode(merge({
    Severity    = "warning"
    Description = "Lambda Function Metrics: https://${module.this.aws_region}.console.aws.amazon.com/lambda/home?region=${module.this.aws_region}#/functions/${local.function_name}?tab=monitoring"
  }, module.cloudwatch_label.tags, module.cloudwatch_label.additional_tag_map))
  alarm_topic_arn = var.alarm_topic_arn != null ? var.alarm_topic_arn : "arn:aws:sns:${module.this.aws_region}:${module.this.aws_account_id}:${module.this.environment}-alarms"
}

resource "aws_iam_role_policy_attachment" "lambda_insights" {
  count = var.insights_enable ? 1 : 0

  policy_arn = data.aws_iam_policy.lambda_insights[0].arn
  role       = aws_iam_role.default.name
}

resource "aws_cloudwatch_metric_alarm" "errors" {
  alarm_description = local.alarm_description
  alarm_name        = "${module.cloudwatch_label.id}-errors"
  count             = var.alarm_enabled ? 1 : 0

  namespace   = "AWS/Lambda"
  metric_name = "Errors"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = var.alarm_errors.datapoints_to_alarm
  evaluation_periods  = var.alarm_errors.evaluation_periods
  period              = var.alarm_errors.period
  statistic           = "Sum"
  tags                = module.cloudwatch_label.tags
  threshold           = var.alarm_errors.threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.default.function_name
  }

  alarm_actions = [local.alarm_topic_arn]
  ok_actions    = [local.alarm_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "success_rate" {
  alarm_description = local.alarm_description
  alarm_name        = "${module.cloudwatch_label.id}-success-rate"
  count             = var.alarm_enabled ? 1 : 0

  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = var.alarm_success_rate.datapoints_to_alarm
  evaluation_periods  = var.alarm_success_rate.evaluation_periods
  tags                = module.cloudwatch_label.tags
  threshold           = var.alarm_success_rate.threshold
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "invocations"
    return_data = false

    metric {
      dimensions = {
        "FunctionName" = aws_lambda_function.default.function_name
      }
      metric_name = "Invocations"
      namespace   = "AWS/Lambda"
      period      = var.alarm_success_rate.period
      stat        = "Sum"
    }
  }

  metric_query {
    id          = "errors"
    return_data = false

    metric {
      dimensions = {
        "FunctionName" = aws_lambda_function.default.function_name
      }
      metric_name = "Errors"
      namespace   = "AWS/Lambda"
      period      = var.alarm_success_rate.period
      stat        = "Sum"
    }
  }

  metric_query {
    expression  = "100-100*(errors/invocations)"
    id          = "e1"
    label       = "success rate"
    return_data = true
  }

  alarm_actions = [local.alarm_topic_arn]
  ok_actions    = [local.alarm_topic_arn]
}

resource "aws_cloudwatch_metric_alarm" "throttles" {
  alarm_description = local.alarm_description
  alarm_name        = "${module.cloudwatch_label.id}-throttles"
  count             = var.alarm_enabled ? 1 : 0

  namespace   = "AWS/Lambda"
  metric_name = "Throttles"

  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = var.alarm_throttles.datapoints_to_alarm
  evaluation_periods  = var.alarm_throttles.evaluation_periods
  period              = var.alarm_throttles.period
  statistic           = "Sum"
  tags                = module.cloudwatch_label.tags
  threshold           = var.alarm_throttles.threshold
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.default.function_name
  }

  alarm_actions = [local.alarm_topic_arn]
  ok_actions    = [local.alarm_topic_arn]
}
