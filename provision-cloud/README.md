# HashiCorp Vault Demonstration - Cloud Provisioning

In this guide, you will deploy a new Vault server instance on AWS. You do not
have to have an existing AWS account before starting. Although the server that
is created will be small, the Free resources for new accounts is very
beneficial for beginners. Everything created here will fall into the free tier
category for new AWS users. After the first year, these resources are **NOT**
free, so be very careful. Also, do not leave these resources existing after
you are done here as you may get charged.

## Preparation

### Sensitive Values

You will need to copy and/or rename the `sensitive.tfvars.example` file to
`sensitive.tfvars` in order for your specific IP address to be picked up
by the Terraform plan. Edit this file and modify the following value to
match your current IP address:

```hcl
my_ip_address = "128.236.17.24"
```

### Non-Sensitive Values

Review the `terraform.tfvars` file to ensure all of the
values specified will work for you. **MOST** are *safe* options and can
be left alone. The one exception is the AWS Region. Edit this value to
set your desired region:

```hcl
aws_region = "ap-northeast-2"
```

I have this set to the Asia (Seoul) region since I live there. Pick a
region close to you...or not. It really doesn't matter for the purpose
of this demonstration.

### AWS Credentials

If you read the various files, you will notice we did not specify any
values for the `aws_access_key` and `aws_secret_key` variables. These
values contain your AWS account credentials and **SHOULD NEVER**
appear anywhere that you do not control. For the purposes of this demo,
we will save these values to special **environment variables** that
Terraform will pick up and use for these values. On a Linux system,
there are two methods for setting an environment variable:

1. Use `export VARIABLE=value`
2. Use `export VARIABLE=$(eval cat sensittive_file.txt)`

Of these two options, I prefer the second because the sensitive value
never is shared to the history of the terminal (and possibly exposed
later). However, it's up to your preference.

If you set these on the command line, they will be good for the
current session and will have to be set whenever you need the values.
You can also add them to your Shell Profile file (e.g., `.bashrc`)
and will be evaluated on every session.

Given my preference, create two files: `.aws_access_key` and
`.aws_secret_key` in your home directory. Copy the AWS Access Key
for your account to the first file and the AWS Secret Key to the
second. Each file should have no contents other than the single
line with these sensitive values. Use any editor of your choice.
Once they are saved to your home directory (**NOT IN A VERSION 
CONTROL FOLDER**), you can type the following:

```bash
export TF_VAR_aws_access_key=$(cat ~/.aws_access_key)
export TF_VAR_aws_secret_key=$(cat ~/.aws_secret_key)
```

You can then type the following and you should see your two
secret variables:

```bash
env | grep TF_VAR
```

## Instructions

Once you've made two listed adjustments above and created your secret
environment variables, you're ready to begin the provisioning process.
Terraform has a standard workflow:

* Initializing
* Planning
* Applying
* Destroying

For this guide, we'll obviously not be doing the last part here. However,
I will provide the instructions so you can remember to remove all of the
AWS resources when you're done with the full demo (don't forget there's
a second part--configuring Vault).

### Initialization

This step will prepare your current folder to use the Terraform tools
and manage your resources. This process includes downloading all
required providers and modules that are referenced throughout your
plan. In this folder, simply type the following:

```bash
terraform init -upgrade
```

You should see something along the lines of this when complete:

```text
```

**NOTE**: You will be storing your State files within this directory.
These files are excluded from Version Control, but you do not want
to delete them. If you manually delete these files before you
destroy the resources managed by Terraform, you will have to manually
remove all of the assets on AWS. This is NOT something you want to be
doing reguarly.

### Planning

This step will walk through your Terraform files, determine the
resoures that will need to be created, the order and dependencies
generated for those resources and display a final plan to you
on the screen. This is a good check to make sure everything that will
be created matches what is intended. To do this step, in this folder
type the following:

```bash
terraform plan -var-file=sensitive.tfvars
```

You will notice I did not specify the `terraform.tfvars` file. This
file is automatically picked up by the Terraform tools. If you want
to not have to specify the file containing the sensitive values, you
will need to rename `sensitive.tfvars` to `sensitive.auto.tfvars`.
Once that is done, you can do this step simply by typing:

```bash
terraform plan
```

A successful plan will have no errors displayed. Possible errors could
stem from an incorrect AWS Access Key or AWS Secret Key which doesn't
have the permission to make changes within your AWS account.

### Provisioning

Once you've confirmed the plan will complete, you're ready to create
the Vault server on AWS. **NOTE: This is the first time you will incur charges**.

```bash
terraform apply -var-file=sensitive.tfvars
```

If you renamed the file previously, you can just type:

```bash
terraform apply
```

You will be prompted to confirm the changes,  Do so by typing `yes`.
This process will take some time. As Terraform creates the resources,
it will provide regular updates every 10 seconds.

## Cleanup

Once the demonstration is complete, you will need to cleanup the
various resources used for this demo. Terraform makes this process
very simple. Simply type the following:

```bash
terraform destroy
```

As with the `apply` step, you will be prompted to confirm the deletion
of the resources. Type `yes` to do so. Terraform will then remove all
of the generated resources in your AWS account that were created by this
demo.

You do not need to worry about removing any other resources that may
exist in your account. Terraform will only remove the assets that it
manages in state.

## Questions / Feedback

I'm always looking for feedback on this demo. If there are things you would
change or improve, please submit them via the project's
[GitHub Issue Tracker](https://github.com/darkhonor/vault-demo/issues).
