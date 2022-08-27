output "lambda_function_arn" {
  value = module.function.arn
}

output "lambda_function_id" {
  value = module.function.id
}

output "lambda_function_service_role_arn" {
  value = module.function.service_role_arn
}

output "lambda_layer_arn" {
  value = module.function.layer_arn
}
