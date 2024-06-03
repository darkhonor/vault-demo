###############################################################################
# Non-Sensitive Values for your installation.
###############################################################################
###########################################################
# AWS Access Variables
###########################################################
aws_region = "ap-northeast-2"

###########################################################
# AWS Networking Variables
###########################################################
name_prefix           = "vault-demo"
server_tls_servername = "vault.demo.local"

###########################################################
# AWS EC2 Instance Variables
###########################################################
ec2_ami_name_prefix     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
ec2_instance_arch       = "x86_64"
ec2_instance_type       = "t2.micro"
ec2_instance_private_ip = "10.20.30.40"
