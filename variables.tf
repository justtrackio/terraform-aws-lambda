variable "alarm_backlog" {
  type = object({
    minutes             = optional(number, 5)
    datapoints_to_alarm = optional(number, 5)
    evaluation_periods  = optional(number, 5)
    period              = optional(number, 300)
    threshold           = optional(number, 1)
  })
  description = "Errors alarm parameters"
  default     = {}
}

variable "alarm_create" {
  type        = bool
  description = "Whether to create the errors and success rate alarms or not"
  default     = true
}

variable "alarm_errors" {
  type = object({
    datapoints_to_alarm = optional(number, 9)
    evaluation_periods  = optional(number, 10)
    period              = optional(number, 300)
    threshold           = optional(number, 1)
  })
  description = "Errors alarm parameters"
  default     = {}
}

variable "alarm_success_rate" {
  type = object({
    datapoints_to_alarm = optional(number, 1)
    evaluation_periods  = optional(number, 1)
    period              = optional(number, 60)
    threshold           = optional(number, 99)
  })
  description = "Success rate alarm parameters"
  default     = {}
}

variable "alarm_throttles" {
  type = object({
    datapoints_to_alarm = optional(number, 2)
    evaluation_periods  = optional(number, 3)
    period              = optional(number, 60)
    threshold           = optional(number, 1)
  })
  description = "Throttles alarm parameters"
  default     = {}
}

variable "alarm_topic_arn" {
  type        = string
  description = "ARN of the SNS Topic used for notifying about alarm/ok messages."
  default     = null
}

variable "architectures" {
  type        = list(string)
  description = "Instruction set architecture for your Lambda function. Valid values are ['x86_64'] and ['arm64']. Default is ['x86_64']. Removing this attribute, function's architecture stay the same"
  default     = null
}

variable "container_image_tag" {
  type        = string
  description = "Tag within the container repository, can e.g. take values from data.aws_ecr_image.my-image.image_tag"
}

variable "container_repository_url" {
  type        = string
  description = "URL of the repository, can e.g. take values from data.aws_ecr_repository.my-repo.repository_url"
}

variable "dead_letter_queue_create" {
  type        = bool
  description = "Defines if you want to add a dead letter queue to your lambda function, capturing all errored events."
  default     = true
}

variable "environment_variables" {
  type        = map(string)
  description = "Map of environment variables to be added to the lambda context."
  default     = {}
}

variable "insights_enable" {
  type        = bool
  description = "Defines whether to attach the required policies to run Lambda Insights."
  default     = true
}

variable "label_orders" {
  type = object({
    cloudwatch = optional(list(string)),
    iam        = optional(list(string)),
    lambda     = optional(list(string)),
    sqs        = optional(list(string)),
  })
  default     = {}
  description = "Overrides the `labels_order` for the different labels to modify ID elements appear in the `id`"
}

variable "memory_size" {
  type        = number
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default     = null
}

variable "reserved_concurrent_executions" {
  type        = number
  description = "Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1"
  default     = null
}

variable "timeout" {
  type        = number
  description = "Timeout ouf the lambda function in seconds."
  default     = 300
}
