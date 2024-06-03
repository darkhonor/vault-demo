###############################################################################
# AWS Key Management Service keys for Vault Demo
#
# This is an actual key managed by AWS for the express purpose of unsealing
# the Vault server. This key will be destroyed when the project is destroyed.
# This *should* fall within the free-tier, but I need to verify.
###############################################################################
resource "aws_kms_key" "vault" {
  description             = "Unseal keys for ${var.name_prefix}'s Vault server"
  deletion_window_in_days = 30
}
