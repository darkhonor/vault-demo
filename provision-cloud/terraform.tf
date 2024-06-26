###############################################################################
# Main Terraform Configuration
###############################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.52.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
}

###############################################################################
# Provider Configuration
###############################################################################
###########################################################
# AWS Provider Configuration
###########################################################
provider "aws" {
  region = var.aws_region

  ##
  # The following two settings are set as Environment Variables
  ##
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  default_tags {
    tags = {
      Environment = "Demo"
    }
  }
}

###########################################################
# CloudInit Provider Configuration
###########################################################
provider "cloudinit" {
  # No configuration required  
}

###########################################################
# Random Provider Configuration
###########################################################
provider "random" {
  # No configuration required
}

###########################################################
# TLS Provider Configuration
###########################################################
provider "tls" {
  # No configuration required
}