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
# Create test admin user
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

###########################################################
# Create test standard user
###########################################################
resource "vault_generic_endpoint" "user" {
  path                 = "auth/${var.auth_path}/users/${var.standard_username}"
  ignore_absent_fields = true

  data_json = jsonencode(
    {
      "policies" : ["standard"],
      "password" : var.standard_password
    }
  )
}

###########################################################
# Create test automation user
###########################################################
resource "vault_generic_endpoint" "gitlab" {
  path                 = "auth/${var.auth_path}/users/${var.gitlab_username}"
  ignore_absent_fields = true

  data_json = jsonencode(
    {
      "policies" : ["gitlab"],
      "password" : var.gitlab_password
    }
  )
}
