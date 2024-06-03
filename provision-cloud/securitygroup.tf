###############################################################################
# AWS Security Group configuration
###############################################################################
resource "aws_security_group" "vault_demo" {
  name        = "${var.name_prefix}-sg"
  description = "Allow inbound traffic to Vault Demo instance"
  vpc_id      = module.demo_vpc.vpc_id

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "default_outbound_ipv6" {
  security_group_id = aws_security_group.vault_demo.id
  description       = "Allow All Outbound IPv6"
  cidr_ipv6         = "::/0"
  ip_protocol       = "tcp"
  from_port         = 0
  to_port           = 0

  tags = {
    Name = "allow-outbound-ipv6"
  }
}

resource "aws_vpc_security_group_egress_rule" "default_outbound_ipv4" {
  security_group_id = aws_security_group.vault_demo.id
  description       = "Allow All Outbound IPv4"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 0
  to_port           = 0

  tags = {
    Name = "allow-outbound-ipv4"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.vault_demo.id
  description       = "Allow Inbound SSH from Home Network"
  cidr_ipv4         = "${var.my_ip_address}/32"
  ip_protocol       = "tcp"
  from_port         = "22"
  to_port           = "22"

  tags = {
    Name = "allow-inbound-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vault" {
  security_group_id = aws_security_group.vault_demo.id
  description       = "Allow Inbound Vault from Home Network"
  cidr_ipv4         = "${var.my_ip_address}/32"
  ip_protocol       = "tcp"
  from_port         = "8200"
  to_port           = "8200"

  tags = {
    Name = "allow-inbound-vault"
  }
}

resource "aws_vpc_security_group_ingress_rule" "postgres" {
  security_group_id = aws_security_group.vault_demo.id
  description       = "Allow Inbound PostgreSQK from Home Network"
  cidr_ipv4         = "${var.my_ip_address}/32"
  ip_protocol       = "tcp"
  from_port         = "5432"
  to_port           = "5432"

  tags = {
    Name = "allow-inbound-pgsql"
  }
}
