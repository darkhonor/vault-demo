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
  user_data_base64            = data.cloudinit_config.vault_demo.rendered
}
