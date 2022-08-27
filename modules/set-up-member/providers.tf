provider "aws" {
  region  = var.base_region
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "apne1"
  region  = "ap-northeast-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "apne2"
  region  = "ap-northeast-2"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "apne3"
  region  = "ap-northeast-3"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "aps1"
  region  = "ap-south-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "apse1"
  region  = "ap-southeast-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "apse2"
  region  = "ap-southeast-2"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "cac1"
  region  = "ca-central-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "euc1"
  region  = "eu-central-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "eun1"
  region  = "eu-north-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "euw1"
  region  = "eu-west-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "euw2"
  region  = "eu-west-2"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "euw3"
  region  = "eu-west-3"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "sae1"
  region  = "sa-east-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "use1"
  region  = "us-east-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "use2"
  region  = "us-east-2"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "usw1"
  region  = "us-west-1"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}

provider "aws" {
  alias   = "usw2"
  region  = "us-west-2"
  profile = var.aws_profile_name
  default_tags {
    tags = {
      Service = var.service_name
    }
  }
}
