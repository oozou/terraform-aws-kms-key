locals {
  tags = {
    Terraform   = true
    Environment = "devops"
  }
}

data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

data "aws_iam_policy_document" "terraform_access_kms" {
  statement {
    sid    = "AllowTerraformToAccesKMSforObjectLevelActionsPurpose"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey*",
    ]
    resources = ["*"]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:user/terraform"]
      type        = "AWS"
    }
  }
}

module "application_bucket_kms" {
  source = "../../"

  prefix               = "oozou"
  environment          = "devops"
  name                 = "application-s3"
  append_random_suffix = true
  description          = "S3 bucket encryption KMS key"
  key_type             = "service"

  service_key_info = {
    caller_account_ids = [data.aws_caller_identity.this.account_id]
    aws_service_names  = ["s3.${data.aws_region.this.name}.amazonaws.com"]
  }

  additional_policies = [
    data.aws_iam_policy_document.terraform_access_kms.json
  ]

  tags = local.tags
}
