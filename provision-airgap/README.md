# KTEN Vault Cluster

This plan will deploy and configure a HashiCorp Vault cluster.

## Server Provisioning

In order to provision the servers on our environment, you will need
to edit the `enclave.auto.tfvars` file with values appropriate for
the enclave.

The key values that need to be updated in this file include:

```hcl
datacenter               = "KBSC_Main"
datastore                = "KTEN-Datastore"
cluster                  = "TestCluster"
folder                   = "Security"
template                 = "linux-oracle-9.3-minimal-24.04"
network_name             = "50_CEIS"
vault_node_ip            = ["192.168.51.31", "192.168.51.32", "192.168.51.33"]
network_netmask          = ["25", "25", "25"]
network_dns              = ["192.168.51.65"]
network_gateway          = ["192.168.51.126"]
domain                   = "kten.test"
instance_qty             = 3
```

When the enclave variables have been updated, run the following
command:

```bash
terraform apply -auto-approve
```

This process should take about 3 minutes (or so depending on your
vCenter infrastructure). You can confirm the servers are created
and running with the correct FQDNs and IP addresses.

## Certificate Generation

You will need to generate an SSL certificate for the Vault cluster. There
are two ways you can handle this:

* Create 1 certificate that is shared among each host
* Create a unique certificate for each host

Both solutions are viable. The first is useful because of 1 thing: it's
simple.  The caveat is that you have to have a SAN for the Cluster API
address as well as for each of the FQDNs for each node in the cluster.

The second solution makes the process of certificate generatation a little
simpler.  You will still need a SAN for the FQDN of the server as well
as the Cluster API address, but not for each node in the cluster.

The key is that TLS will terminate on the Vault cluster and not anywhere
in between. It is considered a Security **BEST PRACTICE** to have TLS
terminate at the host.  Just do it.  It's for the best. With that in mind
either option is good. 

I have included a sample [OpenSSL configuration](files/kten-test.cnf) 
that can be used to generate a certificate signing request using the
first option.

The first step is to generate a private key for the server. **KEEP THIS
FILE SECURE**:

```bash
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out tls.key
```

You would generate the Certificate Signing Request using the following
command:

```bash
openssl req -key tls.key -config kten-test.cnf -new -out vault.csr
```

Submit the CSR to the Online CA to have a new Web SSL Certificate
generated. WHen prompted on the server to download the new certificate,
select the Base64-encoded certificate rather than the DER encoded.
This is the standard format for Linux certificates and will work with
the various web servers here.

Save the generated key and certificate in the `certs` folder here as
`tls.crt` and `tls.key`. These filenames **MUST** match because the
next step will copy these two files to each of the servers.

## Initial Configuration

Once you have confirmed the servers have been created, you can
start the initial configuration.  This step will use Ansible to
format the additional disk that was added to the server, add all
software packages and repository definitions, and install the
Vault software.

To run the playbook, type the following:

```bash
ansible-playbook -i inventory/vault config-vault.yml
```

This will take several steps that are described in the `config-vault.yml`
file comments. When this command finishes, as long as all steps
complete successfully, the server will have the following state:

* Extra disk mounted as an XFS partition mounted at /opt/vault
* HashiCorp Yum repo has been added
* Vault server package has been installed
* Server Certificates installed in /opt/vault/tls
* Enclave CA Certificate Chain installed in /opt/vault/tls
* Vault Server Configuration customized for the host
* Host firewall enabled and allowing access to Vault ports
* Vault Environment Variables added to Ansible User profile
* Vault Service **STOPPED** and **DISABLED**

## HAProxy Configuration

TODO: Need to add an inventory and playbook to configure this next
section. Best to add it to the vault inventory file so you can
reference the proper paths.

In order to configure HA Proxy, add the following two elements to your
Proxy configuration on both the primary and standby HAProxy nodes:

```config
frontend vault
    mode tcp
    log global
    bind 192.168.51.30:443
    description Vault over HTTPS
    default_backend vault_backend
    option tcplog

backend vault_backend
    mode tcp
    option httpchk GET /v1/sys/health
    http-check expect status 200

    # Do not terminate TLS at the proxy
    server vault-01 ceist-vault-01.kten.test:8200 check check-ssl verify none
    server vault-02 ceist-vault-02.kten.test:8200 check check-ssl verify none
    server vault-03 ceist-vault-03.kten.test:8200 check check-ssl verify none
```

Reference: [HAProxy - HashiCorp Vault Playground](https://falcosuessgott.github.io/hashicorp-vault-playground/haproxy/)

## Verify Environment Variable Setup


The `~/.bashrc` file within the `ansible` as part of the initial deployment
should have an entry for the VAULT_ADDR environment variable.  Ensure the
following line is in the `~/.bashrc`:

```bash
export VAULT_ADDR=https://ceist-vault-01.kten.test:8200
```

If this line is here, you can verify it is set by typing:

```bash
echo $VAULT_ADDR
```

As long as this is done on one of the new Vault servers, it
should be present on all of them because of the Ansible playbook.

## Initialize Vault Cluster

This needs to be done on the first node in the cluster. SSH to the
host using the builtin `ansible` user.  Start the Vault service on
this first node:

```bash
sudo systemctl start vault
```

Verify the service started correctly using the following command:

```bash
journalctl -xeu vault.service
```

You can expect to see some errors about attempting to join raft
leader node.  These are expected to appear since the cluster
has not been initlized.  What we are looking for is the following
text:

```text
░ Subject: A start job for unit vault.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://support.oracle.com
░░ 
░░ A start job for unit vault.service has finished successfully.
░░ 
░░ The job identifier is 5447.
```

Hit `q` to exit the `journalctl` application and return to a command
prompt.  Type the following to initialize the Vault cluster and generate
the Unseal Keys. This sets a temporary environment variable to use only
during the execution of this command.  If there are any issues with
this command, you will receive an error message.  A common one is not
being able to locate the URL provided (did you add the A record to DNS?)
or not being able to validate the certificate (did you generate the
certificate and have it copied to the target systems?)

```bash
VAULT_ADDR=https://ceist-vault-01.kten.test:8200 vault operator init -key-shares=10 -key-threshold=2
```

If successful, you should see something similar to the following output:

```text
Unseal Key 1: IA8Yei2j41MDMWG6CZVU8V87KLI4VXJ1Y4L3+UD5Olrp
Unseal Key 2: vB+CxRFcJfeIbXOEYb5CGo1bb+oMLHNLdAT+ErRw5GUR
Unseal Key 3: 9SgoHpVbuXFBW+yoRbqWYW3pBJceaydn9EQ8adkR2R2h
Unseal Key 4: s2h21GWKjNdbMKRQ/hbO4AhyA+zOlCOfqGoY6CQDjOFs
Unseal Key 5: w7WERAZD5ThLqwdN5RWRCECK54tObRyCyFrEAE9t28MY
Unseal Key 6: NbKbRcZeKEkEea4jeWx/Vc2YRR4AoUvscYsdXSWMn/q7
Unseal Key 7: BgKSEHn9E+m2SwiKrFL1amoVggDnz0BF8EZOYsMoTFgp
Unseal Key 8: C2ckB7tlIvTczAQhVvcrRexQD1Wa6fnul/hITTQrp0qz
Unseal Key 9: klobt6shg7nvUltTS02w+LTebA8Z+MicPa3q8LB6qAlg
Unseal Key 10: jLTolUOWyvlS6O7gbgazF6WMtAOGk2gvnnE9H4uceBqa

Initial Root Token: 

Vault initialized with 10 key shares and a key threshold of 2. Please
securely distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 2 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated root key. Without at least 2 keys to
reconstruct the root key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

You can verify the status of Vault using the following command:

```bash
vault status
```

This will generate an output similar to the following:

```text
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       10
Threshold          2
Unseal Progress    0/2
Unseal Nonce       n/a
Version            1.16.2
Build Date         2024-04-22T16:25:54Z
Storage Type       raft
HA Enabled         true
```

This states that:

1) The Vault server is responding as expected
2) The Vault cluster is using an High Availability (HA) config
3) The Vault store is Initialized but still sealed
4) There are 10 shares for the unseal key
5) Two unseal keys are required to unseal the server and none have been applied
6) Raft (Integrated Storage) is being used

In order to start joining the other cluster members, you will need to unseal
the cluster.  You do that by typing the following:

```bash
vault operator unseal
```

When prompted for an `Unseal Key`, copy the value of one of the Unseal Keys
saved earlier.  If it is a good key, you will see the following:

```text
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       10
Threshold          2
Unseal Progress    1/2
Unseal Nonce       3ecc0015-aee1-b35e-729b-e993712180e2
Version            1.16.2
Build Date         2024-04-22T16:25:54Z
Storage Type       raft
HA Enabled         true
```

You can see that the `Unseal Progress` now reflects 1 of 2 keys. Do this
step with a **DIFFERENT** key and you should see the following:

```text
Key                     Value
---                     -----
Seal Type               shamir
Initialized             true
Sealed                  false
Total Shares            10
Threshold               2
Version                 1.16.2
Build Date              2024-04-22T16:25:54Z
Storage Type            raft
Cluster Name            vault-cluster-7f3189b2
Cluster ID              df40cd84-eaaf-eed5-6a65-8e2aa50fd101
HA Enabled              true
HA Cluster              n/a
HA Mode                 standby
Active Node Address     <none>
Raft Committed Index    29
Raft Applied Index      29
```

The `Sealed` status now shows `false` and you are able to start to interact
with the cluster.  In order to do much more with the Vault cluster, you
will need to add a new environment variable.  We are not going to add this
to the user's profile so it will **NOT** persist between sessions. Type the
following command:

```bash
export VAULT_TOKEN=
```

You will want to make sure to use the **Initial Root Token** value you
received when initializing the first host.  

Once this is set, you should be able to do the next couple of steps.  As a
reminder, you will need to set this environment variable on every server
using the **SAME** token.

Run the following command to check to make sure the cluster is responding:

```bash
vault operatro members
```

This will show the details of all the nodes in the cluster. At this point,
you will probably only see this first node until the other nodes are
added as shown here:

```text
```

Additionally, you should check the HA Proxy Stats webpage to make sure that
the Proxy Server is showing the correct value.  This *should* work as long
as you configured the Proxy appropriately in the previous section.

Open the following URL in your web browser: <http://ceist-lb-01.kten.test:8080>

You should see an entry for the vault_backend and one of the systems should
be green.  If you then navigate to <https://vault.kten.test> you should

 1) Successfully see the Vault homepage
 2) Have a trusted certificate with no certificate warnings

## Add Second Vault Server to Cluster

Now that the cluster is funtioning with the Proxy/Load Balancer, it's time
to add the other two nodes to the cluster (if you're going to have a true
HA cluster).

Log into the second Vault server using SSH:

```bash
ssh ansible@ceist-vault-02.kten.test
```

Start the Vault service:

```bash
sudo systemctl start vault
```

Make sure the service starts cleanly as you did previously.  You will use
the same troubleshooting methods as previously mentioned.

Now, instead of *initializing* the Vault cluster (since we've already done
that on the first server), we're going to just unseal it:

```bash
vault operator unseal
```

Use two more of the keys (they can be the same ones as previous) you received
during the initialization step above. Once complete, you should be able to
check the Vault status and see that it is initialized and unsealed:

```text
```

Because of the `retry_join` stanza in the `/etc/vault.d/vault.hcl` file, the
server should automatically join the Raft cluster using the Load Balanced
address.

Check the Vault logs if there are any issues and you don't see output as shown
above.

Repeat the steps in this section on the final server.  Once complete, you should
be able to check the vault cluster membership using the following command:

```bash
vault operator members
```

You should see all three hosts listed here with one of the hosts showing as the
leader or active node.

**CONGRATULATIONS!!!** You have successfully deployed a Highly Available
Vault Cluster to the enclave. The remainder of the configuration will be done
via Terraform in a different project folder.

Please pass any feedback or questions on this guide or the project files in this
folder to <alexander.l.ackerman.civ@army.mil>.
