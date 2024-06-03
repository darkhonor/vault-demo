###############################################################################
# Main Configuration File
# 
# This file will contain the majority of the resources generated. I will be
# taking advantage of some public modules to simplify the code here. Just
# understand there are a lot of steps behind the scenes being taken here, but
# are not relevant for this demonstration.
###############################################################################
##############################################################
# Lookup for Ubuntu 22.04 x64 AMI
##############################################################
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ec2_ami_name_prefix]
  }

  filter {
    name   = "architecture"
    values = [var.ec2_instance_arch]
  }
}

##############################################################
# Cloud Init Configuration
##############################################################
data "cloudinit_config" "vault" {
  gzip          = false
  base64_encode = true

  part {
    filename     = "userdata.yaml"
    content_type = "text/cloud-config"
    content      = file("${path.module}/../config/vault-userdata.yaml")
  }

  part {
    filename     = "vault.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/../scripts/vault-setup.sh", {
      SERVER_CA          = tls_self_signed_cert.ca_cert.cert_pem
      SERVER_PUBLIC_KEY  = tls_locally_signed_cert.server_cert.cert_pem
      SERVER_PRIVATE_KEY = tls_private_key.server_key.private_key_pem
      REGION             = var.aws_region
      KMS_KEY_ID         = aws_kms_key.vault.key_id
    })
  }
}

###########################################################
# Create the Demo Instance using Ubuntu 22.04 AMI
###########################################################
module "demo_instance" {
  source        = "terraform-aws-modules/ec2-instance/aws"
  version       = "value"
  name          = "demo-vault"
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = "some value"
  monitoring    = false
  metadata_options = {
    "http_endpoint" : "enabled"
    "http_protocol_ipv6" : "enabled"
    "http_put_response_hop_limit" : 1
    "http_tokens" : "required"
  }
  vpc_security_group_ids      = [aws_security_group.vault_demo.id]
  subnet_id                   = "some values"
  associate_public_ip_address = true
  private_ip                  = var.ec2_instance_private_ip
  user_data_base64            = data.cloudinit_config.vault.rendered
}

