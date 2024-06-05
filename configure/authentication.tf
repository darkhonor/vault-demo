###############################################################################
# Authentication Provider Configuration
###############################################################################
###########################################################
# Enable Username/Password Authentication
###########################################################
resource "vault_auth_backend" "userpass" {
  path = var.auth_path
  type = "userpass"
}

###########################################################
# Create test user
###########################################################
resource "vault_generic_endpoint" "admin" {
  path                 = "auth/${var.auth_path}/users/${var.admin_username}"
  ignore_absent_fields = true

  data_json = jsonencode(
    {
      "policies" : ["admins"],
      "password" : var.admin_password
    }
  )
}
