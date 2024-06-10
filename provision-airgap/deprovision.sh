#!/bin/sh
#
# Deprovision the Server leveraging Terraform (and update the state file)
#
/usr/bin/ssh-keygen -f ~/.ssh/known_hosts -R 192.168.51.31

terraform destroy -var-file=enclave.tfvars

