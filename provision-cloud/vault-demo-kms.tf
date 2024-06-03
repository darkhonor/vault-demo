###############################################################################
# AWS Key Management Service keys for Vault Demo
###############################################################################
resource "aws_kms_key" "vault" {
  description             = "Unseal keys for ${var.name_prefix}'s Vault server"
  deletion_window_in_days = 30
}
