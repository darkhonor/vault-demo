###############################################################################
# Networking Configuration
###############################################################################
###########################################################
# Create a Demo VPC with a single public subnet
###########################################################
module "demo_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name           = "${var.vpc_name}-vpc"
  cidr           = "10.20.0.0/16"
  azs            = data.aws_availability_zones.available.names
  public_subnets = ["10.20.30.0/24"]

  manage_default_route_table = true
  default_route_table_tags   = { DefaultRouteTable = true }

  enable_nat_gateway   = false
  enable_dns_hostnames = true
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}