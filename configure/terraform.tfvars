###############################################################################
# Terraform Values
###############################################################################
###########################################################
# Vault Variables
###########################################################
vault_server         = "https://vault.kten.test"
vault_token_path     = "/home/aackerman/.cluster-vault-token"
vault_unverified_ssl = false

###########################################################
# Authentication Variables
###########################################################
auth_path      = "userpass"
admin_username = "admin_user"
admin_password = "Sup3rS3kR3tP@s$w0rd!"
standard_username = "joe.user"
standard_password = "NotAStrongPassword!"
gitlab_username = "gitlab.svc"
gitlab_password = "DoesThisThingEverChange?"

###########################################################
# Key-Value Engine Variables
###########################################################
kv2_engine_mount     = "StaticStore"
vcenter_secrets_path = "vCenter"
vcenter_hostname     = "vcs.kten.test"

###########################################################
# Certificate Authority Variables
###########################################################
root_ca_path             = "pki_root"
ica_path                 = "pki_int"
ca_keytype               = "rsa"
ca_keysize               = "4096"
root_ca_default_duration = 157680000 # 5 Years
root_ca_max_duration     = 315360000 # 10 Years
root_ca_common_name      = "KTEN Root CA"
root_ca_issuer_name      = "kten-root"
ica_default_duration     = 31536000  # 1 Year
ica_max_duration         = 157680000 # 5 Years
ica_common_name          = "KTEN Vault CA-01"
ica_ca_issuer_name       = "kten-intermediate"
country                  = "US"
organization             = "U.S. Government"
ou                       = "DoD"
ca_signature_algorithm   = "SHA384WithRSA"

###########################################################
# Vault Policy Variables
###########################################################
vault_admin_policy_name = "admins"

###########################################################
# Database Engine Variables
###########################################################
db_username = "dbservice"
db_password = "NotAGoodServicePassword"
db_hostname = "localhost"
db_port = 5432
db_name = "vaultdemo"
