# AWS KMS Key

AWS Key Management Service (KMS) makes it easy for you to create and manage cryptographic keys and control their use across a wide range of AWS services and in your applications. This component creates a KMS key that is used to encrypt data across the platform.

It creates:

- *KMS key*: Resource which creates KMS key
- *KMS key policy*: Key policies which permits cross account access, access through AWS principles and AWS services based on some conditions and input variables

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
  source      = "git::https://<YOUR_VCS_URL>/components/terraform-aws-kms-key?ref=v4.1.0"
  key_type    = "service"
  description = "Used to encrypt log aggregation resources"
  alias_name  = local.kms_alias_name

  service_key_info = "${map(
    "aws_service_names", list(format("s3.%s.amazonaws.com", data.aws_region.current.name)),
    "caller_account_ids", list(data.aws_caller_identity.current.account_id)
  )}"
}
```
