/*
data "aws_secretsmanager_secret_version" "bigip-pw" {
  secret_id = data.aws_secretsmanager_secret.big-ip.id
}
*/

/*
resource "bigip_do" "do-this" {
  do_json = file("${path.module}/do-declaration.json")
  timeout = 15
}
*/

data "aws_network_interface" "aws-nics" {
  count = length(var.public_nic_ids)
  id    = var.public_nic_ids[count.index]
}

resource "bigip_sys_dns" "f5csdns" {
  description    = "/Common/F5CS-DNS"
  name_servers   = ["107.162.158.150", "107.162.158.151"]
  number_of_dots = 2
  search         = ["f5cs.tech"]
}

resource "bigip_sys_ntp" "ntpsrv" {
  description = "/Common/ntpd"
  servers     = ["time.facebook.com"]
  timezone    = "America/Los_Angeles"
}

resource "bigip_sys_provision" "do-provision-asm" {
  name      = "sre-eap-asm"
  full_path = "asm"
  level     = "normal"
}

resource "bigip_sys_provision" "do-provision-ltm" {
  name      = "sre-eap-eap"
  full_path = "ltm"
  level     = "normal"
}

resource "bigip_net_vlan" "external" {
  name = "/Common/extVLAN"
  tag  = 10
  interfaces {
    vlanport = 1.1
    tagged   = false
  }
}

resource "bigip_net_vlan" "internal" {
  name = "/Common/intVLAN"
  tag  = 20
  interfaces {
    vlanport = 1.2
    tagged   = false
  }
}

resource "bigip_net_selfip" "selfip2" {
  count = length(var.azs)
  name          = "/Common/intSelfIP"
  ip            = join("/", [element(flatten(data.aws_network_interface.aws-nics[count.index].private_ips), 2), "24"])
  vlan          = "/Common/intVLAN"
  traffic_group = "traffic-group-local-only"
  depends_on    = [bigip_net_vlan.internal]
}
/*
resource "bigip_net_selfip" "selfip2" {
  count = length(var.azs)
  name          = "/Common/internalselfIP"
  ip            = join("/", ["${element(flatten(data.aws_network_interface.bar[count.index].private_ips), 2)}", "24"])
  vlan          = "/Common/Internal-TF"
  traffic_group = "traffic-group-local-only"
  depends_on    = [bigip_net_vlan.internal]
}
*/