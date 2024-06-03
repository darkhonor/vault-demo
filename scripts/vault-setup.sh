#!/bin/sh
###############################################################################
# HashiCorp Vault Server Configuration Script
###############################################################################
###########################################################
# Install AWS CLI
###########################################################
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

instance_id=$( curl -Ss -H "X-aws-ec2-metadata-token: $imds_token" 169.254.169.254/latest/meta-data/instance-id )

###########################################################
# Create appropriate data directories
###########################################################
mkdir -p /opt/vault.d
chown vault:vault -R /opt/vault.d
chmod g+rwx /opt/vault.d

###########################################################
# Save generated CA and TLS Certificates to the server
###########################################################
cat > /opt/vault/tls/ca.crt <<- EOF
${SERVER_CA}
EOF

cat > /opt/vault/tls/tls.crt <<- EOF
${SERVER_PUBLIC_KEY}
EOF

cat > /opt/vault/tls/tls.key <<- EOF
${SERVER_PRIVATE_KEY}
EOF

###########################################################
# Create Vault Configuration File
###########################################################
cat > /etc/vault.d/vault.hcl <<- EOF
ui = true

cluster_addr = "https://{{ GetPrivateIP }}:8201"

api_addr = "https://{{ GetPrivateIP }}:8200"

disable_mlock = true

storage "raft" {
  path    = "/opt/vault.d/"
  node_id = "$${instance_id}"
}

seal "awskms" {
  region     = "${REGION}"
  kms_key_id = "${KMS_KEY_ID}"
}

listener "tcp" {
  address            = "0.0.0.0:8200"
  tls_cert_file      = "/opt/vault/tls/tls.crt"
  tls_key_file       = "/opt/vault/tls/tls.key"
  tls_client_ca_file = "/opt/vault/tls/ca.crt"
}
EOF

###########################################################
# Enable and Start the Vault Service
###########################################################
systemctl enable vault
systemctl start vault

export VAULT_CACERT=/opt/vault/tls/ca.crt
vault operator init -format=json > /opt/vault/root.json

cat > /opt/vault/vault.env <<- EOF
export VAULT_CACERT=/opt/vault/tls/ca.crt
export VAULT_TOKEN=$(cat /opt/vault/root.json | jq -r .root_token)
EOF

mkdir -p /opt/vault/pki

cat > /opt/vault/pki/extfile.cnf <<- EOF
basicConstraints=CA:TRUE
authorityKeyIdentifier=keyid
EOF

cat > /opt/vault/pki/offline_ca.sh <<- EOF
export CERT_C="US"
export CERT_ST="California"
export CERT_L="San Francisco"

mkdir -p /opt/vault/pki/root
mkdir -p /opt/vault/pki/intermediate

openssl genrsa -des3 -out /opt/vault/pki/root/ca.key 4096
openssl req -new -x509 -days 3650 -key /opt/vault/pki/root/ca.key \
    -out /opt/vault/pki/root/ca.crt \
    -subj "/C=$${CERT_C}/ST=$${CERT_ST}/L=$${CERT_L}/O=HashiCorp/OU=Community/CN=Example Root CA"

### GET CSR FROM VAULT!

openssl x509 -req -in /opt/vault/pki/intermediate/ca.csr \
    -extfile /opt/vault/pki/extfile.cnf \
    -CA /opt/vault/pki/root/ca.crt -CAkey /opt/vault/pki/root/ca.key \
    -CAcreateserial -out /opt/vault/pki/intermediate/ca.crt -days 1096 -sha256
EOF

###########################################################
# Force APT to use IPv6
###########################################################
# cat > /etc/apt/apt.conf.d/1000-force-ipv6-transport <<- EOF
# Acquire::ForceIPv6 "true";
# EOF

###########################################################
# Ensure Firewall is Disabled--use Security Groups
###########################################################
systemctl disable --now ufw.service
