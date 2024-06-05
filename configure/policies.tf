###############################################################################
# Vault Policy Configurations
###############################################################################
###########################################################
# Admin Policy Configuration
###########################################################
resource "vault_policy" "admin_policy" {
  name   = "admins"
  policy = file("policies/admin-policy.hcl")
}

###########################################################
# Standard User Policy Configuration
###########################################################
resource "vault_policy" "user_policy" {
  name   = "standard"
  policy = file("policies/user-policy.hcl")
}

###########################################################
# GitLab Service Policy Configuration
###########################################################
resource "vault_policy" "gitlab_policy" {
  name   = "gitlab"
  policy = file("policies/gitlab-policy.hcl")
}
