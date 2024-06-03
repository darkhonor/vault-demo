###############################################################################
# Variable Definitions
###############################################################################
variable "vault_server" {
  description = "URL to the Vault Instance"
  type        = string
}

variable "vault_token_path" {
  description = "Path to the authentication token for the Vault Instance"
  type        = string
}

variable "vault_unverified_ssl" {
  description = "Boolean on whether the TLS certificate can be trusted"
  type        = bool
}