provider "aws" {
  region  = var.base_region
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}
