provider "bigip" {
  address = var.bigip_mgmt_public_ip
  username = var.bigip_mgmt_admin
  password = var.bigip_mgmt_passwd
}

resource "bigip_as3"  "do-this" {
  as3_json = file("${path.module}/files/as3-common-declaration.json")
  tenant_name = "thang"
}
