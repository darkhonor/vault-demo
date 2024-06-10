#####
# Vault Resources
#####
data "vault_kv_secret_v2" "vcenter" {
  mount = var.kv2_engine_mount
  name  = var.vcenter_secrets_path
}

