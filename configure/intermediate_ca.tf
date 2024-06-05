###############################################################################
# Intermediate CA Configuration
###############################################################################
###########################################################
# Create Intermediate CA PKI Engine
###########################################################
resource "vault_mount" "int_ca" {
  path                      = var.ica_path
  type                      = "pki"
  description               = "PKI Engine hosting Intermediate CA"
  default_lease_ttl_seconds = var.ica_default_duration
  max_lease_ttl_seconds     = var.ica_max_duration
}

###########################################################
# Create Certificate Signing Request for Intermediate CA Cert
###########################################################
resource "vault_pki_secret_backend_intermediate_cert_request" "int_csr" {
  backend      = vault_mount.int_ca.path
  type         = "internal"
  key_type     = var.ca_keytype
  key_bits     = var.ca_keysize
  common_name  = var.ica_common_name
  country      = var.country
  organization = var.organization
  ou           = var.ou
}

#######################################
# Export Intermediate CA CSR to file
#######################################
resource "local_file" "int_ca_csr" {
  content         = vault_pki_secret_backend_intermediate_cert_request.int_csr.csr
  filename        = "${path.module}/certs/intermediate_ca.csr"
  file_permission = "0444"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "int_cert" {
  backend     = vault_mount.root_ca.path
  common_name = var.ica_common_name
  csr         = vault_pki_secret_backend_intermediate_cert_request.int_csr.csr
  format      = "pem_bundle"
  ttl         = var.root_ca_default_duration
  issuer_ref  = vault_pki_secret_backend_root_cert.root_cert.issuer_id
}

resource "local_file" "int_ca_cert" {
  content         = vault_pki_secret_backend_root_sign_intermediate.int_cert.certificate
  filename        = "${path.module}/certs/intermediate_ca.pem"
  file_permission = "0444"
}

###########################################################
# Configure Intermediate CA Certificate Backend Issuer
###########################################################
resource "vault_pki_secret_backend_intermediate_set_signed" "int_ca" {
  backend     = vault_mount.int_ca.path
  certificate = vault_pki_secret_backend_root_sign_intermediate.int_cert.certificate
}

resource "vault_pki_secret_backend_issuer" "int_ca" {
  backend                        = vault_mount.int_ca.path
  issuer_ref                     = vault_pki_secret_backend_intermediate_set_signed.int_ca.imported_issuers[0]
  issuer_name                    = var.ica_ca_issuer_name
  revocation_signature_algorithm = var.ca_signature_algorithm
}

resource "vault_pki_secret_backend_role" "intermediate" {
  backend         = vault_mount.int_ca.path
  name            = "int-ca"
  key_type        = var.ca_keytype
  key_bits        = var.ca_keysize
  country         = [var.country]
  organization    = [var.organization]
  ou              = [var.ou]
  allow_ip_sans   = true
  allow_localhost = false
  allow_subdomains = true
  allowed_domains = ["ktenk.kor.cmil.mil", "kten.imn.cmil.mil"]
}

resource "vault_pki_secret_backend_config_urls" "int_ca" {
  backend                 = vault_mount.int_ca.path
  issuing_certificates    = ["${var.vault_server}/v1/${var.ica_path}/ca"]
  crl_distribution_points = ["${var.vault_server}/v1/${var.ica_path}/crl"]
}