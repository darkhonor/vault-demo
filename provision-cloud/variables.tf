###############################################################################
# Variable Definitions
###############################################################################
###########################################################
# AWS Access Variables
###########################################################
variable "aws_region" {
  description = "Region code for your instance"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  description = "AWS Access Key for your account"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key for your account"
  type        = string
  sensitive   = true
}

###########################################################
# AWS Networking Variables
###########################################################
variable "name_prefix" {
  description = "Name prefix for AWS resources"
  type        = string
  default     = "demo"
}

variable "my_ip_address" {
  description = "Your IP address to restrict access to the EC2 instance"
  type        = string
}

###########################################################
# AWS Instance Variables
###########################################################
variable "ec2_ami_name_prefix" {
  description = "Name prefix for the Ubuntu 22.04 AMI"
  type        = string
}

variable "ec2_instance_arch" {
  description = "Architecture for the AMI to use"
  type        = string
  default     = "x86_64"
}

variable "ec2_instance_type" {
  description = "Instance size for the AWS instance."
  type        = string
  default     = "t2.micro"
}

variable "ec2_instance_private_ip" {
  description = "Private IP address to use for the Ec2 instance"
  type        = string
}