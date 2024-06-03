###############################################################################
# Main Terraform Configuration
###############################################################################
terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.2.0"
    }
  }
}

###############################################################################
# Provider Configuration
###############################################################################
###########################################################
# Vault Provider Configuration
###########################################################
provider "vault" {
  address = var.vault_server
  auth_login_token_file {
    filename = var.vault_token_path
  }
  token_name      = "Terraform"
  skip_tls_verify = var.vault_unverified_ssl
}
