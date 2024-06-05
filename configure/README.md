# Vault Configuration Demo

This Terraform plan will create a set of demonstration capabilities on
an established [HashiCorp Vault](https://www.vaultproject.io) instance.
This plan assumes that you have a valid [Root token](https://developer.hashicorp.com/vault/docs/concepts/tokens#root-tokens)
for the Vault instance.  Edit the `terraform.tfvars` file to make the
appropriate adjustments. Some variables to pay close attention to:

```hcl
vault_server         = "https://vault.kten.test"
vault_token_file     = "/home/aackerman/.cluster-vault-token"
```

In reality, the only critical values that need to be corrected for this
demo plan to apply are the `vault_server` and `vault_token_file` values.
All of the other values that will be created can stay the same as they
are not used outside of this demonstration, nor do they have a dependency
on anything that may or may not exist in your infrastructure.

I wanted to provide a fairly complex configuration, as simply as possible,
in order to show you how you can create and manage your Vault configuration
via IaC languages, such as Terraform. **NEVER STORE SECRETS IN TERRAFORM
DIRECTLY AS DONE HERE**. If you need to seed your vault instance with
sensitive values, either create them directly, restore from another Vault
instance backup, or use another appropriate tool (such as 
[Ansible Vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html)). A demonstration of Ansible Vault is outside of the scope of this
demo, but may be included later.

This demo takes advantage of the [Tutorial](https://developer.hashicorp.com/vault/tutorials/secrets-management/pki-engine)
provided by HashiCorp on the Vault website. For additonal examples, that is
a phenomenal resource on usage of Vault with many different scenarios.

## Instructions

To use this demo, have your Vault instance created and update the
`terraform.tfvars` file accordingly. Once that is complete, type the
following within this directory:

```bash
terraform init -upgrade
```

If you are in an airgap environment and unable to access the Internet,
you will need to have a repository available for the Terraform Plugins.
In this use case, type the following (substituting `/opt/terraform` for
the correct path for you):

```bash
terraform init -upgrade -plugin-dir=/opt/terraform
```

As long as this does not error, type the following to validate and see what
will be created by this plan:

```bash
terraform plan
```

If this completes successfully and you're good with the objects that will
be created, type the following to configure your Vault instance:

```bash
terraform apply -auto-approve
```

This will connect to the Vault server and create the structure that is 
defined in this demo.

## Capabilities Demonstrated

This demo plan will create the following Engines within your Vault
instance:

* Username / Password Authentication Engine with 1 user
* Static Secrets Engine with 1 secret
* Vault Admin Policy to apply to created user
* Database Secrets Engine (TBD)
* PKI Engine implementing a Root CA
* PKI Engine implementing an Intermediate CA under the Root CA
* Generate a Signed Certificate for a Vault server using the ICA
