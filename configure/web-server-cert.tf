###############################################################################
# Sample Vault Server Certificate Request
###############################################################################
resource "vault_pki_secret_backend_cert" "vault" {
  issuer_ref           = vault_pki_secret_backend_issuer.int_ca.issuer_ref
  backend              = vault_pki_secret_backend_role.intermediate.backend
  name                 = vault_pki_secret_backend_role.intermediate.name
  common_name          = "vault.ktenk.kor.cmil.mil"
  exclude_cn_from_sans = false
  alt_names = [
    "vault-01.ktenk.kor.cmil.mil",
    "vault-02.ktenk.kor.cmil.mil",
    "vault-03.ktenk.kor.cmil.mil"
  ]
  ttl                   = 7776000 # 90-Day Certificate
  auto_renew            = true
  min_seconds_remaining = 604800 # 7 Days Remaining
  revoke                = true
}

output "vault_certificate" {
  value = vault_pki_secret_backend_cert.vault.certificate
}

resource "local_file" "vault_cert" {
  content         = vault_pki_secret_backend_cert.vault.certificate
  filename        = "${path.module}/certs/vault.crt"
  file_permission = "0444"
}

resource "local_sensitive_file" "vault_key" {
  content         = vault_pki_secret_backend_cert.vault.private_key
  filename        = "${path.module}/certs/vault.key"
  file_permission = "0400"
}
