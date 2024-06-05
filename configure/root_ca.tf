###############################################################################
# Root CA Configuration
###############################################################################
###########################################################
# Create Root CA PKI Engine
###########################################################
resource "vault_mount" "root_ca" {
  path                      = var.root_ca_path
  type                      = "pki"
  description               = "PKI Engine hosting Root CA"
  default_lease_ttl_seconds = var.root_ca_default_duration
  max_lease_ttl_seconds     = var.root_ca_max_duration
}

###########################################################
# Create Self-Signed Root Certificate
###########################################################
resource "vault_pki_secret_backend_root_cert" "root_cert" {
  backend      = vault_mount.root_ca.path
  type         = "internal"
  common_name  = var.root_ca_common_name
  issuer_name  = var.root_ca_issuer_name
  ttl          = var.root_ca_max_duration
  key_type     = var.ca_keytype
  key_bits     = var.ca_keysize
  country      = var.country
  organization = var.organization
  ou           = var.ou
}

#######################################
# Export Root CA Certificate to file
#######################################
resource "local_file" "root_ca_cert" {
  content         = vault_pki_secret_backend_root_cert.root_cert.certificate
  filename        = "${path.module}/certs/root_ca.crt"
  file_permission = "0444"
}

###########################################################
# Configure Root CA Certificate Backend Issuer
###########################################################
resource "vault_pki_secret_backend_issuer" "root_ca" {
  backend                        = vault_mount.root_ca.path
  issuer_ref                     = vault_pki_secret_backend_root_cert.root_cert.issuer_id
  issuer_name                    = vault_pki_secret_backend_root_cert.root_cert.issuer_name
  revocation_signature_algorithm = var.ca_signature_algorithm
}

resource "vault_pki_secret_backend_role" "root" {
  backend         = vault_mount.root_ca.path
  name            = "root-ca"
  key_type        = var.ca_keytype
  key_bits        = var.ca_keysize
  country         = [var.country]
  organization    = [var.organization]
  ou              = [var.ou]
  allow_ip_sans   = true
  allow_localhost = false
}

resource "vault_pki_secret_backend_config_urls" "root" {
  backend                 = vault_mount.root_ca.path
  issuing_certificates    = ["http://${var.vault_server}:8200/v1/${var.root_ca_path}/ca"]
  crl_distribution_points = ["http://${var.vault_server}:8200/v1/${var.root_ca_path}/crl"]
}