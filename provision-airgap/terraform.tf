###############################################################################
# Terraform Configuration
###############################################################################
###########################################################
# Version Configuration
###########################################################
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3.3"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.2.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = ">= 3.15.0"
    }
  }
}

###########################################################
# Provider Configuration
###########################################################
provider "cloudinit" {
  # Configuration options
}

provider "vsphere" {
  user                 = data.vault_kv_secret_v2.vcenter.data["username"]
  password             = data.vault_kv_secret_v2.vcenter.data["password"]
  vsphere_server       = data.vault_kv_secret_v2.vcenter.data["vcenter_hostname"]
  allow_unverified_ssl = var.vcenter_unverified_ssl
}

provider "vault" {
  address         = var.vault_server
  token_name      = "Terraform"
  skip_tls_verify = var.vault_unverified_ssl
}

