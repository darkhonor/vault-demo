#!/bin/sh
#
# provision.sh: Run the Ansible and Terraform Playbooks / Plans
#

#ansible-playbook -i inventory main.yml

terraform apply

#ansible-playbook main.yml -i inventory/rancher.yml 
