provider "aws" {
  region = "us-east-2"
}

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}


module "kms_service" {
  source = "../.."

  prefix      = "oozou"
  environment = "dev"
  name        = "s3_key"

  key_type    = "service"
  description = "Used to encrypt log aggregation resources"
  append_random_suffix = true
  deletion_window = 7

  service_key_info = {
    aws_service_names  = tolist([format("s3.%s.amazonaws.com", data.aws_region.current.name)])
    caller_account_ids = tolist([data.aws_caller_identity.current.account_id])
  }


  tags = { "Workspace" = "000-test" }
}

module "kms_direct" {
  source = "../.."

  prefix      = "oozou"
  environment = "dev"
  name        = "app_key"


  key_type    = "direct"
  description = "Used to encrypt application"
  append_random_suffix = true
  deletion_window = 7

  direct_key_info = {
    allow_access_from_principals = tolist(["arn:aws:iam::xxxxx:role/sample-role"])
    }


  tags = { "Workspace" = "000-test" }
}