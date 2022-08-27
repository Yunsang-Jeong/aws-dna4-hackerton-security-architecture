resource "null_resource" "layer" {
  count = var.create_lambda_layer ? 1 : 0

  triggers = {
    modify = "${local.source_code_dir}/requirements.txt"
    exist  = fileexists("${local.source_code_dir}/layer.zip")
  }

  provisioner "local-exec" {
    command = "pip install -r ${local.source_code_dir}/requirements.txt -t ${local.source_code_dir}/layer/python/lib/python3.9/site-packages/ --platform linux_x86_64 --only-binary :all: --disable-pip-version-check"
  }
}

data "archive_file" "layer" {
  count = var.create_lambda_layer ? 1 : 0

  type        = "zip"
  source_dir  = "${local.source_code_dir}/layer"
  output_path = "${local.source_code_dir}/layer.zip"

  depends_on = [
    null_resource.layer
  ]
}

resource "aws_lambda_layer_version" "layer" {
  count = var.create_lambda_layer ? 1 : 0

  layer_name          = "${var.service_name}-${var.event_handler_name}-layer"
  filename            = data.archive_file.layer[0].output_path
  source_code_hash    = data.archive_file.layer[0].output_base64sha256
  compatible_runtimes = [var.lambda_runtime]
}
