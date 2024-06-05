###############################################################################
# Terraform Variable Definitions
###############################################################################
###########################################################
# Vault Variables
###########################################################
variable "vault_server" {
  description = "URL for the HashiCorp Vault Server"
  type        = string
}

variable "vault_token_file" {
  description = "Filename containing a Vault Token"
  type        = string
}

variable "vault_unverified_ssl" {
  description = "Whether you are going to allow unverified SSL certificates"
  type        = bool
}

###########################################################
# Authentication Variables
###########################################################
variable "auth_path" {
  description = "Path for Username / Password Authentication Method"
  type        = string
}

variable "admin_username" {
  type        = string
  description = "Username for the Vault Administrator"
}

variable "admin_password" {
  type        = string
  description = "Password for the Vault Administrator"
  sensitive   = true
}

###########################################################
# Key-Value Engine Variables
###########################################################
variable "kv2_engine_mount" {
  description = "Path to the KV V2 secrets engine"
  type        = string
}

variable "vcenter_secrets_path" {
  description = "Path to the vCenter secrets in the Vault Server"
  type        = string
}

variable "vcenter_hostname" {
  type        = string
  description = "Hostname for the vCenter Server"
}

###########################################################
# Certificate Authority Variables
###########################################################
variable "root_ca_path" {
  description = "Path to the Root CA PKI Engine"
  type        = string
}

variable "ica_path" {
  description = "Path to the Intermediate CA PKI Engine"
  type        = string
}

variable "ca_keytype" {
  description = "Type of the Key used for the Root and Intermediate CAs"
  type        = string
}

variable "ca_keysize" {
  description = "Key Size in bits for the Keys issued by the CA"
  type        = string
}

variable "root_ca_default_duration" {
  description = "Duration of the default Certificate Validity in seconds"
  type        = number
}

variable "root_ca_max_duration" {
  description = "Duration of the Max Certificate Validity in seconds"
  type        = number
}

variable "root_ca_common_name" {
  description = "Common Name (CN) for the Root Certificate Authority"
  type        = string
}

variable "root_ca_issuer_name" {
  description = "Issuer Name for the Root Certificate Authority.  Cannot contain spaces."
  type        = string
}

variable "ica_default_duration" {
  description = "Duration of the default Certificate Validity in seconds"
  type        = number
}

variable "ica_max_duration" {
  description = "Duration of the Max Certificate Validity in seconds"
  type        = number
}

variable "ica_common_name" {
  description = "Common Name (CN) for the Intermediate Certificate Authority Certificate"
  type        = string
}

variable "ica_ca_issuer_name" {
  description = "Issuer Name for the Intermediate Certificate Authority. Cannot contain spaces."
  type        = string
}

variable "country" {
  description = "Country value for Certificates issued by CA"
  type        = string
}

variable "organization" {
  description = "Organization value for Certificates issued by CA"
  type        = string
}

variable "ou" {
  description = "OU value for Certificates issued by CA"
  type        = string
}

variable "ca_signature_algorithm" {
  description = "Signature Algorithm used by CAs"
  type        = string
}

###########################################################
# Vault Policy Variables
###########################################################
variable "vault_admin_policy_name" {
  description = "Name of the Admin Policy"
  type        = string
}