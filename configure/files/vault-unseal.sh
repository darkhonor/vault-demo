#!/bin/sh
#
# Unseal local vault instance
#

VAL1=$(< /etc/vault.d/vault-unseal-1.key)
VAL2=$(< /etc/vault.d/vault-unseal-2.key)
export VAULT_ADDR="https://vault.kten.test"
#export VAULT_SKIP_VERIFY=true

vault operator unseal $VAL1
vault operator unseal $VAL2
