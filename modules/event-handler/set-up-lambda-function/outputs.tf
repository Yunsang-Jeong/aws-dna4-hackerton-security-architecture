output "arn" {
  value = aws_lambda_function.this.arn
}

output "id" {
  value = aws_lambda_function.this.id
}

output "service_role_arn" {
  value = aws_iam_role.service_role.arn
}

output "service_role_name" {
  value = aws_iam_role.service_role.name
}

output "layer_arn" {
  value = var.create_lambda_layer ? aws_lambda_layer_version.layer : null
}
