#####
# vSphere Tags - Mandatory Tags for KTEN Systems
#####
data "vsphere_tag_category" "prod" {
  name = "terraform-prod-category"
}

data "vsphere_tag_category" "classification" {
  name = "CLASSIFICATION"
}

data "vsphere_tag_category" "caveat" {
  name = "CLASSIFICATION_CAVEAT"
}

data "vsphere_tag" "production" {
  name        = "Production"
  category_id = data.vsphere_tag_category.prod.id
}

data "vsphere_tag" "ceis" {
  name        = "CEIS"
  category_id = data.vsphere_tag_category.prod.id
}

data "vsphere_tag" "unclass" {
  name        = "UNCLASSIFIED"
  category_id = data.vsphere_tag_category.classification.id
}

data "vsphere_tag" "caveat_none" {
  name        = "NONE"
  category_id = data.vsphere_tag_category.caveat.id
}

data "vsphere_tag_category" "opr" {
  name = "OPR"
}

data "vsphere_tag" "cio" {
  name        = "CIO"
  category_id = data.vsphere_tag_category.opr.id
}
