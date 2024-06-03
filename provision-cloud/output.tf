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
output "ca_cert" {
  value = tls_self_signed_cert.ca_cert.cert_pem
}
