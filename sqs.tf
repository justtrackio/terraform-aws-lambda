module "dead_letter_queue" {
  count = var.dead_letter_queue_create ? 1 : 0

  source  = "justtrackio/sqs-queue/aws"
  version = "1.4.0"

  context    = module.sqs_label.context
  queue_name = "dead"

  alarm_create              = var.alarm_create
  alarm_minutes             = var.alarm_backlog.minutes
  alarm_datapoints_to_alarm = var.alarm_backlog.datapoints_to_alarm
  alarm_evaluation_periods  = var.alarm_backlog.evaluation_periods
  alarm_period              = var.alarm_backlog.period
  alarm_threshold           = var.alarm_backlog.threshold
  aws_account_id            = var.aws_account_id
  aws_region                = var.aws_region
}

data "aws_iam_policy_document" "dead_letter_queue_access" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [module.dead_letter_queue[0].queue_arn]
  }
}

resource "aws_iam_role_policy" "dead_letter_queue" {
  count = var.dead_letter_queue_create ? 1 : 0

  role   = aws_iam_role.default.name
  name   = "${module.iam_label.id}-dead-letter-queue"
  policy = data.aws_iam_policy_document.dead_letter_queue_access.json
}