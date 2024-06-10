#
# Variables definitions
#
variable "vault_server" {
  description = "URL for the HashiCorp Vault Server"
  type        = string
}

variable "vault_unverified_ssl" {
  description = "Whether you are going to allow unverified SSL certificates"
  type        = bool
}

variable "kv2_engine_mount" {
  description = "Path to the KV V2 secrets engine"
  type        = string
}

variable "vcenter_secrets_path" {
  description = "Path to the vCenter secrets in the Vault Server"
  type        = string
}

variable "vcenter_unverified_ssl" {
  description = "Whether you are going to allow unverified SSL certificates"
  type        = bool
}

variable "module_version" {
  description = "Version number for the vSphere VM Terraform module"
  type        = string
}

variable "datacenter" {
  description = "The Datacenter to Host all Resources"
  type        = string
}

variable "cluster" {
  description = "The name of the Compute Cluster"
  type        = string
}

variable "datastore" {
  description = "The datastore to deploy a VM to"
  type        = string
}

variable "network_name" {
  description = "The Distributed Port Group or Standard Port Group to attach to the VM"
  type        = string
}

variable "folder" {
  description = "The Virtual Machine folder to place the new VM"
  type        = string
}
variable "template" {
  description = "The Virtual Machine Template to use to create the Virtual Machine"
  type        = string
}

variable "vmname_vault" {
  description = "Hostname for the new master node. Can be combined with dynamic text for multiple VMs"
  type        = string
}

variable "domain" {
  description = "DNS Domain Name for the new Virtual Machine"
  type        = string
}

variable "vault_node_ip" {
  description = "Static IP Address for the new Virtual Machine"
  type        = list(any)
}

variable "network_netmask" {
  description = "The netmask (24 for a 255.255.255.0 netmask) for the new Virtual Machine"
  type        = list(any)
}

variable "network_gateway" {
  description = "The IPv4 Gateway address for the new Virtual Machine"
  type        = list(any)
}

variable "network_dns" {
  description = "List of DNS Servers to assign to the new Virtual Machine"
  type        = list(any)
}

variable "vm_disk1_vault_size" {
  description = "Size in GB for the VM Disk.  If not included, leave null"
  type        = number
}

variable "vm_disk_thin_provisioned" {
  description = "Whether or not to thin provision a disk.  This is standard for all disks"
  type        = bool
}

variable "vm_memory_mb" {
  description = "Size in MB for the Virtual Machine RAM"
  type        = number
}

variable "vm_num_cpus" {
  description = "Number of Virtual CPUs for the Virtual Machine"
  type        = number
}

variable "instance_qty" {
  description = "Number of RKE2 Controller instances to create"
  type        = number
}
