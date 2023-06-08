# AWS KMS Key

AWS Key Management Service (KMS) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications. This component creates a KMS key that is used to encrypt data across the platform.

It creates:

- _KMS key_: Resource which creates KMS key
- _KMS key policy_: Key policies which permits cross account access, access through AWS principles and AWS services based on some conditions and input variables

## Architecture

[TODO] Insert Architecture Diagram

## Run-Book

### Pre-requisites

#### IMPORTANT NOTE

1. Required version of Terraform is mentioned in `meta.tf`.
2. Go through `variables.tf` for understanding each terraform variable before running this component.

#### AWS Accounts

Needs the following accounts:

1. Compute/Spoke Account (AWS account where KMS Key is to be created)

### Getting Started

#### How to use this component in a blueprint

IMPORTANT: We periodically release versions for the components. Since, master branch may have on-going changes, best practice would be to use a released version in form of a tag (e.g. ?ref=x.y.z)

```terraform
module "logs_kms" {
  source      = "git::https://<YOUR_VCS_URL>/components/terraform-aws-kms-key?ref=<ref_name>"
  key_type    = "service"
  description = "Used to encrypt log aggregation resources"
  prefix      = "<customer_name>"
  name        = "<paas_name>"
  environment = "devops"

  service_key_info = {
    aws_service_names  = tolist([format("s3.%s.amazonaws.com", data.aws_region.current.name)])
    caller_account_ids = tolist([data.aws_caller_identity.current.account_id])
  }

  additional_policies = [data.aws_iam_policy_document.cloudtrail.json, data.aws_iam_policy_document.flow_logs.json]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version           |
|---------------------------------------------------------------------------|-------------------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0          |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 5.0.0, < 6.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random)          | >= 3.1.0          |

## Providers

| Name                                                       | Version |
|------------------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws)          | 5.1.0   |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1   |

## Modules

No modules.

## Resources

| Name                                                                                                                                               | Type        |
|----------------------------------------------------------------------------------------------------------------------------------------------------|-------------|
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)                                        | resource    |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)                                            | resource    |
| [random_string.random_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string)                               | resource    |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                      | data source |
| [aws_iam_policy_document.admin_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)         | data source |
| [aws_iam_policy_document.direct_cryptography](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)  | data source |
| [aws_iam_policy_document.kms_key_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)       | data source |
| [aws_iam_policy_document.service_cryptography](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name                                                                                               | Description                                                                                                                                                            | Type                                                                                                                                                                                                                                                                   | Default                                                                       | Required |
|----------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|:--------:|
| <a name="input_additional_policies"></a> [additional\_policies](#input\_additional\_policies)      | Additional IAM policies block, input as data source. Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document           | `list(string)`                                                                                                                                                                                                                                                         | `[]`                                                                          |    no    |
| <a name="input_append_random_suffix"></a> [append\_random\_suffix](#input\_append\_random\_suffix) | Append a random string to the alias name. Default: true (yes)                                                                                                          | `bool`                                                                                                                                                                                                                                                                 | `true`                                                                        |    no    |
| <a name="input_deletion_window"></a> [deletion\_window](#input\_deletion\_window)                  | Number of days before a key actually gets deleted once it's been scheduled for deletion. Valid value between 7 and 30 days                                             | `number`                                                                                                                                                                                                                                                               | `30`                                                                          |    no    |
| <a name="input_description"></a> [description](#input\_description)                                | The description to give to the key                                                                                                                                     | `string`                                                                                                                                                                                                                                                               | n/a                                                                           |   yes    |
| <a name="input_direct_key_info"></a> [direct\_key\_info](#input\_direct\_key\_info)                | Information required for a 'direct' key                                                                                                                                | <pre>object({<br>    # List of principals to allow for cryptographic use of key.<br>    allow_access_from_principals = list(string)<br>  })</pre>                                                                                                                      | <pre>{<br>  "allow_access_from_principals": []<br>}</pre>                     |    no    |
| <a name="input_environment"></a> [environment](#input\_environment)                                | Environment name used as environment resources name.                                                                                                                   | `string`                                                                                                                                                                                                                                                               | n/a                                                                           |   yes    |
| <a name="input_key_type"></a> [key\_type](#input\_key\_type)                                       | Indicate which kind of key to create: 'service' for key used by services; 'direct' for other keys. Must provide service\_key or direct\_key maps depending on the type | `string`                                                                                                                                                                                                                                                               | n/a                                                                           |   yes    |
| <a name="input_name"></a> [name](#input\_name)                                                     | Name used as a resources name.                                                                                                                                         | `string`                                                                                                                                                                                                                                                               | n/a                                                                           |   yes    |
| <a name="input_prefix"></a> [prefix](#input\_prefix)                                               | The prefix name of customer to be displayed in AWS console and resource.                                                                                               | `string`                                                                                                                                                                                                                                                               | n/a                                                                           |   yes    |
| <a name="input_service_key_info"></a> [service\_key\_info](#input\_service\_key\_info)             | Information required for a 'service' key                                                                                                                               | <pre>object({<br>    # List of AWS service names for the kms:ViaService policy condition<br>    aws_service_names = list(string)<br>    # List of caller account IDs for the kms:CallerAccount policy condition<br>    caller_account_ids = list(string)<br>  })</pre> | <pre>{<br>  "aws_service_names": [],<br>  "caller_account_ids": []<br>}</pre> |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                     | Tags to add more; default tags contian {terraform=true, environment=var.environment}                                                                                   | `map(string)`                                                                                                                                                                                                                                                          | `{}`                                                                          |    no    |

## Outputs

| Name                                                        | Description |
|-------------------------------------------------------------|-------------|
| <a name="output_key_arn"></a> [key\_arn](#output\_key\_arn) | KMS key arn |
| <a name="output_key_id"></a> [key\_id](#output\_key\_id)    | KMS key id  |
<!-- END_TF_DOCS -->
