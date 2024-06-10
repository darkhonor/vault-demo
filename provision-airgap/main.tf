#####
# Primary Terraform configuration.  This will create a new Windows Server VM based upon the 
# VMware vm module and the specified template.
#####
###
# Deploy Vault Node
###
module "vault" {
  source = "git::ssh://git@gitlab.kten.test/kbsc/kten_terraform/terraform-vsphere-vm.git"
  //version = "3.8.0"
  dc               = var.datacenter
  vmrp             = "${var.cluster}/Resources"
  datastore        = var.datastore
  vmfolder         = var.folder
  vmtemp           = var.template
  is_windows_image = false
  instances        = var.instance_qty
  vmname           = var.vmname_vault
  vmnameformat     = "-%02d"
  cpu_number       = var.vm_num_cpus
  ram_size         = var.vm_memory_mb
  data_disk = {
    disk1 = {
      size_gb                   = var.vm_disk1_vault_size,
      thin_provisioned          = var.vm_disk_thin_provisioned,
      data_disk_scsi_controller = 0
    }
  }
  network = {
    "${var.network_name}" = var.vault_node_ip
  }

  ipv4submask     = var.network_netmask
  dns_server_list = var.network_dns
  vmgateway       = var.network_gateway[0]
  domain          = var.domain

  tags = {
    "${data.vsphere_tag_category.prod.name}"            = "${data.vsphere_tag.production.name}",
    "${data.vsphere_tag_category.prod.name}"            = "${data.vsphere_tag.ceis.name}",
    "${data.vsphere_tag_category.classification.name}"  = "${data.vsphere_tag.unclass.name}",
    "${data.vsphere_tag_category.caveat.name}"          = "${data.vsphere_tag.caveat_none.name}"
    "${data.vsphere_tag_category.opr.name}"             = "${data.vsphere_tag.cio.name}"
  }
}
