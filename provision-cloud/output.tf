###############################################################################
# Terraform Outputs for Use Later
###############################################################################
###########################################################
# URL to the Vault Server once cloud-init finishes
###########################################################
output "vault_url" {
  value = "https://${module.demo_instance.public_dns}:8200"
}

###########################################################
# CA Certificate to "Trust" for the Demo
###########################################################
# output "ca_cert" {
#   value = tls_self_signed_cert.ca_cert.cert_pem
# }

# output "demo_key_private" {
#   value     = module.demo_keypair.private_key_openssh
#   sensitive = true
# }
resource "local_file" "ca_cert" {
  filename        = "${path.module}/certs/vault-demo-ca.crt"
  file_permission = "0444"
  content         = tls_self_signed_cert.ca_cert.cert_pem
}

resource "local_sensitive_file" "keypair_private_key" {
  filename        = "${path.module}/certs/vault-demo-ssh.key"
  file_permission = "0400"
  content         = module.demo_keypair.private_key_openssh
}
