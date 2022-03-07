resource "aws_kms_key" "service_key" {
  description             = var.description
  enable_key_rotation     = true
  deletion_window_in_days = var.deletion_window

  policy = data.aws_iam_policy_document.kms_key_policy_via_service[0].json

  tags = merge({
    Name  = local.alias_name
    Alias = var.alias_name
  }, var.custom_tags)

  count = local.service_key_count
}

resource "aws_kms_alias" "service_key" {
  name          = "alias/${local.alias_name}"
  target_key_id = aws_kms_key.service_key[0].key_id
  count         = local.service_key_count
}

data "aws_iam_policy_document" "admin_policy" {
  statement {
    sid = "Allow Admin" # Root user will have permissions to manage the CMK, but do not have permissions to use the CMK in cryptographic operations. - https://docs.aws.amazon.com/kms/latest/developerguide/concepts.html#cryptographic-operations
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}
data "aws_iam_policy_document" "kms_key_policy_via_service" {
  # dynamic "statement" {
  #   for_each = var.additional_statements
  #   content {
  #     sid = statement.value.sid

  #     actions = [
  #       "kms:Encrypt",
  #       "kms:Decrypt",
  #       "kms:ReEncrypt*",
  #       "kms:GenerateDataKey*",
  #       "kms:CreateGrant",
  #       "kms:DescribeKey",
  #     ]

  #     resources = ["*"]

  #     dynamic "principals" {
  #       for_each = lookup(statement.value, "principals", [])
  #       content {
  #         type        = lookup(principals.value, "type", "AWS")
  #         identifiers = lookup(principals.value, "identifiers", ["*"])
  #       }
  #     }

  #     dynamic "condition" {
  #       for_each = lookup(statement.value, "condition", [])
  #       content {
  #         test     = lookup(condition.value, "test", null)
  #         variable = lookup(condition.value, "variable", null)
  #         values   = lookup(condition.value, "values", [])
  #       }
  #     }


  #   }
  # }

  # statement {
  #   sid = "Allow Cryptography"

  #   actions = [
  #     "kms:Encrypt",
  #     "kms:Decrypt",
  #     "kms:ReEncrypt*",
  #     "kms:GenerateDataKey*",
  #     "kms:CreateGrant",
  #     "kms:DescribeKey",
  #   ]

  #   resources = ["*"]

  #   principals {
  #     type        = "AWS"
  #     identifiers = ["*"]
  #   }

  #   condition {
  #     test     = "StringEquals"
  #     variable = "kms:ViaService"
  #     values   = var.service_key_info.aws_service_names
  #   }

  #   condition {
  #     test     = "StringEquals"
  #     variable = "kms:CallerAccount"
  #     values   = var.service_key_info.caller_account_ids
  #   }
  # }
  source_policy_documents   = [data.aws_iam_policy_document.admin_policy.json]
  override_policy_documents = var.additional_policies
  count                     = local.service_key_count
}
