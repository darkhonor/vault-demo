###############################################################################
# Database Secrets Engine -- Dynamic Secrets with PostgreSQL
###############################################################################
###########################################################
# Enable Secrets Engine
###########################################################
resource "vault_mount" "postgres" {
  path = "postgres"
  type = "database"
}

resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.postgres.path
  name          = "postgres"
  allowed_roles = ["dev", "prod"]

  postgresql {
    connection_url = "postgres://${var.db_username}:${var.db_password}@${var.db_hostname}:${var.db_port}/${var.db_name}"
  }
}

resource "vault_database_secret_backend_role" "role" {
  backend             = vault_mount.postgres.path
  name                = "dev"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';"]
}