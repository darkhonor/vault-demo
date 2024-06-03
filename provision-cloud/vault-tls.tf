###############################################################################
# Create Self-Signed TLS Certificates for Demo Server
# 
# NOTE: This does NOT use a proper CA or Vault to manage certificates. This is
# really only to be used in this demo environment. The provider does allow for
# use with an actual CA, but that is beyond the scope of this Demo.
###############################################################################
###########################################################
# Create Self-Signed CA Certificate for Demo
###########################################################
resource "tls_private_key" "ca_key" {
  algorithm = "RSA"
  rsa_bits  = 4096 # must be 2048 to work with ACM
}

resource "tls_self_signed_cert" "ca_cert" {
  private_key_pem   = tls_private_key.ca_key.private_key_pem
  is_ca_certificate = true

  subject {
    common_name = "ca.vault.demo"
  }

  validity_period_hours = 8760 # 1 year

  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}

###########################################################
# Create Server TLS Certificate signed by CA
###########################################################
resource "tls_private_key" "server_key" {
  algorithm = "RSA"
  rsa_bits  = 4096 # must be 2048 to work with ACM
}

resource "tls_cert_request" "server_csr" {
  private_key_pem = tls_private_key.server_key.private_key_pem
  subject {
    common_name = var.server_tls_servername
  }
  dns_names = [
    var.server_tls_servername,
    "localhost"
  ]
  ip_addresses = concat(["127.0.0.1"], var.ec2_instance_private_ip)
}

resource "tls_locally_signed_cert" "server_cert" {
  cert_request_pem = tls_cert_request.server_csr.cert_request_pem

  ca_private_key_pem = tls_private_key.ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca_cert.cert_pem

  allowed_uses = [
    "client_auth",
    "digital_signature",
    "key_agreement",
    "key_encipherment",
    "server_auth",
  ]

  validity_period_hours = 8760 # 1 Year
}
