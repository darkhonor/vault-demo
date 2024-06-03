# HashiCorp Vault Demonstration

## Introduction

This repository contains a demonstration of Infrastructure As Code (IaC) using
an instance of [HashiCorp Vault](https://vaultproject.io) as the target
application.

The purpose of this demonstration is to show how you can effectively and
quickly deploy and manage services with the following conditions:

* Resources to deploy service are stored in Version Control
* Sensitive Values are **NOT** stored in Version Control
* Methods for provisioning new resources are idempotent
* Examples given can easily transition to other services
* Demonstration can work in both online and airgap environments

In light of the last condition, the provision step below will include steps
to deploy *either* in an airgap VMware vSphere environment *or* to a
Cloud Service Provider (CSP) resource.

If you notice I am using the term **services** rather than **servers**, you
would be very attentive to detail. This is intentional. It is important to
remember why we are running servers--to provide a service. With the changing
landscape, the concept of "servers" is also changing. There are many cases
now in production where **serverless** services are growing in both popularity
and capability across many vendors and environments.

All of the source code for this demonstration will be kept in a public
[GitHub Repository](https://github.com/darkhonor/vault-demo).

## Provision

This is the first step to follow. However, as mentioned previsouly, you have
two paths you can follow.

1. Deploy to a Cloud Instance
2. Deploy to an Airgap vSphere Instance

Although the second option specifies an airgap (i.e., no Internet connectivity)
environment, it will work with any on-prem VMware vSphere environment. I have
found a severe gap in online examples for airgap environments, which I find
I work in regularly for work. The lack of Internet connectivity introduces some
unique challenges which have to be planned for and overcame in order to
successfully deploy new services.

In addition to the HashiCorp Vault Server that will be installed, I will also
include a PostgreSQL database server on the instance for use as an example of
a use-case for dynamic credentials.

### Cloud Instance

The first example will deploy a single instance to a Cloud-hosted environment.
With security in mind, the instance will also have some basic security controls
added limiting exposure of your instance to your IP address only. In a true
production environment, there would be **MANY** more security controls applied.
Since this instance is intended to be destroyed shortly after creation, minimal
protections are required in order to allow you to access your service and control
the instance.

Follow the Instructions [HERE](provision-cloud/README.md) to deploy the instance.

### Airgap vSphere Instance

The second example 

## Configure

Regardless of which route you took, this step will be be the same. In this step,
you will configure the following capabilities on your new Vault server instance:

* Root Certificate Authority
* Intermediate Certificate Authority
* Vault Server TLS certificate signed by Intermediate CA
* Username / Password authentication configured with two demo users
  * admin-user: Full admin rights to the Vault server
  * sever-admin: Access to KV store and Intermediate CA to request Certificates
* Security Policies configured for the two user roles
* Key-Value Static Secrets Store
* Database Dyncamic Secrets Engine configured for PostgreSQL server on server

Follow the Instructions [HERE](configure/README.md) to configure the instance

## References and Credits

I would not be where I'm at in my understanding without the following fantastic
resources. Credit to these giants for helping me get to where I'm at. I have
tried to distill their guides into a single demonstration, but know I'm not
covering nearly half of what they have. Check their guides and examples for
deeper understanding.

* [Getting Into Vault]() - YouTube playlist by HashiCorp
