data "aws_caller_identity" "current" {}

locals {
  service_key_count = var.key_type == "service" ? 1 : 0
  alias_name        = "${var.alias_name}${var.append_random_suffix ? "-${random_string.random_suffix.result}" : ""}"
}
