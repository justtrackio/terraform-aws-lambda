locals {
  dead_letter_arns = var.dead_letter_queue_create ? [module.dead_letter_queue[0].queue_arn] : []
  function_name    = module.lambda_label.id
}

resource "aws_lambda_function" "default" {
  function_name = local.function_name
  role          = aws_iam_role.default.arn

  image_uri    = "${var.container_repository_url}:${var.container_image_tag}"
  package_type = "Image"

  architectures                  = var.architectures
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions
  tags                           = module.lambda_label.tags
  timeout                        = var.timeout

  dynamic "vpc_config" {
    for_each = length(var.vpc_config) > 0 ? [true] : []
    content {
      ipv6_allowed_for_dual_stack = lookup(var.vpc_config, "ipv6_allowed_for_dual_stack")
      security_group_ids          = lookup(var.vpc_config, "security_group_ids")
      subnet_ids                  = lookup(var.vpc_config, "subnet_ids")
    }
  }

  dynamic "dead_letter_config" {
    for_each = local.dead_letter_arns
    content {
      target_arn = dead_letter_config.value
    }
  }

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [true] : []
    content {
      variables = var.environment_variables
    }
  }
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${aws_lambda_function.default.function_name}"
  retention_in_days = 7
  tags              = module.this.tags
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "default" {
  name = module.iam_label.id

  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
  tags               = module.iam_label.tags
}

data "aws_iam_policy_document" "log_stream_access" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.default.arn}:*",
      "arn:aws:logs:${module.this.aws_region}:${module.this.aws_account_id}:log-group:/aws/lambda-insights:*"
    ]
    effect = "Allow"
  }
}

resource "aws_iam_role_policy" "logs" {
  name = "${module.iam_label.id}-logs"

  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.log_stream_access.json
}
