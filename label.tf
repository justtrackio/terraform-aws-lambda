module "cloudwatch_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context     = module.this.context
  label_order = var.label_orders.cloudwatch
}

module "iam_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context     = module.this.context
  label_order = var.label_orders.iam
}

module "lambda_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context     = module.this.context
  label_order = var.label_orders.lambda
}

module "sqs_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context     = module.this.context
  label_order = var.label_orders.sqs
}
