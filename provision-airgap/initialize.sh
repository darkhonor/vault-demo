#!/bin/sh
#
# Initialize the Terraform Plan
#
ansible-galaxy install -r roles/requirements.yml --force -p roles/

terraform init -plugin-dir /opt/terraform/mirror/
