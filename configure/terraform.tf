###############################################################################
# Main Terraform Configuration
###############################################################################
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.0"
    }
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
# Local Provider Configuration
###########################################################
provider "local" {
  # No configuration required
}

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
