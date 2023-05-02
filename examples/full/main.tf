# tflint-ignore: aws_resource_missing_tags
resource "aws_sns_topic" "alarm" {
  name = "foo-alarm-topic"
}

module "example" {
  source = "../.."

  namespace   = "ns"
  environment = "env"
  stage       = "st"
  name        = "app"
  attributes  = ["foo"]
  label_orders = {
    cloudwatch = ["environment", "stage", "name", "attributes"]
    iam        = ["environment", "stage", "name", "attributes"]
    lambda     = ["environment", "stage", "name", "attributes"]
    sqs        = ["stage", "name", "attributes"]
  }

  alarm_create = true
  alarm_backlog = {
    minutes             = 5
    datapoints_to_alarm = 5
    evaluation_periods  = 5
    period              = 300
    threshold           = 1
  }
  alarm_errors = {
    datapoints_to_alarm = 9
    evaluation_periods  = 10
    period              = 300
    threshold           = 1
  }
  alarm_success_rate = {
    datapoints_to_alarm = 9
    evaluation_periods  = 10
    period              = 300
    threshold           = 1
  }
  alarm_throttles = {
    datapoints_to_alarm = 9
    evaluation_periods  = 10
    period              = 300
    threshold           = 1
  }
  alarm_topic_arn          = aws_sns_topic.alarm.arn
  architectures            = ["x86_64"]
  aws_account_id           = "1234567890101"
  aws_region               = "eu-central-1"
  container_image_tag      = "latest"
  container_repository_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/hello-world"
  dead_letter_queue_create = true
  environment_variables = {
    foo = "bar"
  }
  insights_enable                = true
  memory_size                    = 256
  reserved_concurrent_executions = 10
  timeout                        = 60
}
