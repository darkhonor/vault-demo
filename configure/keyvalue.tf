###############################################################################
# Key-Value Secrets Engine Configuration
###############################################################################
resource "vault_mount" "kv2_engine" {
  path        = var.kv2_engine_mount
  type        = "kv-v2"
  description = "KV (v2) Static Secrets Engine"
}

resource "vault_kv_secret_backend_v2" "kv2_backend" {
  mount        = vault_mount.kv2_engine.path
  max_versions = 3
  cas_required = false
}

###########################################################
# Initial Secrets
#   DO NOT STORE SENSITIVE VALUES HERE IN PRODUCTION
###########################################################
resource "vault_kv_secret_v2" "vcenter" {
  mount = vault_mount.kv2_engine.path
  name  = var.vcenter_secrets_path
  data_json = jsonencode(
    {
      vcenter_hostname = var.vcenter_hostname
    }
  )
}
