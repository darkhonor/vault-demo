###############################################################################
# Networking Configuration
###############################################################################
###########################################################
# Create a Demo VPC with a single public subnet
###########################################################
module "demo_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name                    = "${var.name_prefix}-vpc"
  cidr                    = "10.20.0.0/16"
  azs                     = data.aws_availability_zones.available.names
  public_subnets          = ["10.20.30.0/24"]
  public_subnet_names     = ["${var.name_prefix}-subnet"]
  enable_dns_hostnames    = true
  map_public_ip_on_launch = true

  # manage_default_route_table = true
  # default_route_table_tags   = { DefaultRouteTable = true }
  create_igw = true

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_ipv6                                   = false
  public_subnet_assign_ipv6_address_on_creation = false
  create_egress_only_igw                        = false

}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}