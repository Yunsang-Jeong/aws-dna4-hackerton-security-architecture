skip                          = true
terragrunt_version_constraint = ">= 0.36"
terraform_version_constraint  = ">= 1.1.0"

locals {
  service_name             = "sauron"
  backend_s3_profile_name  = "_NEED_TO_INPUT_"
  backend_s3_bucket_name   = "_NEED_TO_INPUT_"
  backend_s3_bucket_region = "ap-northeast-2"

  #
  # config.yaml 파일을 가져오고 값을 저장합니다.
  #
  config                         = yamldecode(file("./config.yaml"))
  base_region                    = local.config.base_region
  base_region_alias              = local.config.base_region_alias
}

#
# 공통적으로 모든 module에 input(variables)되는 값입니다.
#
inputs = {
  service_name            = local.service_name
  base_region_alias       = local.base_region_alias
  base_region             = local.base_region
  patterns_encoded_yaml   = yamlencode(local.config.patterns)
  event_handler_src_dir   = "${get_repo_root()}/event-handler-src"
}

#
# Backend 설정입니다.
#
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    profile = local.backend_s3_profile_name
    region  = local.backend_s3_bucket_region
    bucket  = local.backend_s3_bucket_name
    key     = "${path_relative_to_include()}/terraform.tfstate"
    encrypt = true
  }
}
