output "key_arn" {
  value = join("", aws_kms_key.this.*.arn)
}

output "key_id" {
  value = join("", aws_kms_key.this.*.key_id)
}
