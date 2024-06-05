# Manage auth methods broadly across Vault
path "auth/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Create, update, and delete auth methods
path "sys/auth/*"
{
  capabilities = ["create", "update", "delete", "sudo"]
}

# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# Create and manage ACL policies
path "sys/policies/acl/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List ACL policies
path "sys/policies/acl"
{
  capabilities = ["list"]
}

# Create and manage secrets engines broadly across Vault.
path "sys/mounts/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List enabled secrets engines
path "sys/mounts"
{
  capabilities = ["read", "list"]
}

# Read health checks
path "sys/health"
{
  capabilities = ["read", "sudo"]
}

# List, create, update, and delete key/value secrets at StaticStore/
path "StaticStore/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Full rights on the Root CA PKI Engine
path "pki_root/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Full rights on the Intermediate CA PKI Engine
path "pki_int/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# List, create, update, and delete key/value secrets at StaticStore/
#path "postgres/*"
#{
#  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
#}
