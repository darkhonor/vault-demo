# List auth methods
path "sys/auth"
{
  capabilities = ["read"]
}

# List, create, update, and delete key/value secrets at StaticStore/
path "StaticStore/*"
{
  capabilities = ["read", "list"]
}

# Full rights on the Intermediate CA PKI Engine
path "pki_int/*"
{
  capabilities = ["read","create","update"]
}
