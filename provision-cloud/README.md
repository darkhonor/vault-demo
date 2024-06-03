# HashiCorp Vault Demonstration - Cloud Provisioning

In this guide, you will deploy a new Vault server instance on AWS. You do not
have to have an existing AWS account before starting. Although the server that
is created will be small, the Free resources for new accounts is very
beneficial for beginners. Everything created here will fall into the free tier
category for new AWS users. After the first year, these resources are **NOT**
free, so be very careful. Also, do not leave these resources existing after
you are done here as you may get charged.

## Preparation

You will need to copy and/or rename the `sensitive.tfvars.example` file to
`sensitive.tfvars` in order for your specific IP address to be picked up
by the Terraform plan. Edit this file and modify the following value to
match your current IP address:

```hcl
my_ip_address = "128.236.17.24"
```

Save this file. Review the `terraform.tfvars` file to ensure all of the
values specified will work for you. **MOST** are *safe* options and can
be left alone. The one exception is the AWS Region. Edit this value to
set your desired region:

```hcl
aws_region = "ap-northeast-2"
```

I have this set to the Asia (Seoul) region since I live there. Pick a
region close to you...or not. It really doesn't matter for the purpose
of this demonstration.
