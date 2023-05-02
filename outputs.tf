output "function_arn" {
  description = "ARN of the lambda function"
  value       = aws_lambda_function.default.arn
}

output "function_name" {
  description = "Name of the lambda function"
  value       = aws_lambda_function.default.function_name
}

output "iam_role_name" {
  description = "IAM role name used to execute the function"
  value       = aws_iam_role.default.name
}
