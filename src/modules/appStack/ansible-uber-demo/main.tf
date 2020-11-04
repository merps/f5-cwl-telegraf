data "aws_network_interface" "bar" {
  count = length(var.aws_build.azs)
  id    = var.bip.public_nic_ids[count.index]
}
#
# Create interface for BIG-IP virtual server - juiceshop
#
resource "aws_eip" "juiceshop" {
  depends_on                = [null_resource.hostvars]
  count                     = length(var.aws_build.azs)
  vpc                       = true
  network_interface         = data.aws_network_interface.bar[count.index].id
  associate_with_private_ip = element(flatten(data.aws_network_interface.bar[count.index].private_ips), 1)
  tags = {
    Name = format("%s-juiceshop-eip-%s%s", var.aws_build.prefix, var.aws_build.random, count.index)
  }
}
#
# Create interface for BIG-IP virtual server - grafana
#
resource "aws_eip" "grafana" {
  depends_on                = [null_resource.hostvars]
  count                     = length(var.aws_build.azs)
  vpc                       = true
  network_interface         = data.aws_network_interface.bar[count.index].id
  associate_with_private_ip = element(flatten(data.aws_network_interface.bar[count.index].private_ips), 2)
  tags = {
    Name = format("%s-grafana-eip-%s%s", var.aws_build.prefix, var.aws_build.random, count.index)
  }
}
#
# Create and place the inventory.yml file for the ansible demo
#
resource "null_resource" "hostvars" {
  count = length(var.aws_build.azs)
  provisioner "file" {
    content = templatefile(
      "${path.module}/files/hostvars_template.yml",
      {
        bigip_host_ip        = join(",", [element(var.bip.bigip_mgmt_addr, count.index)])
        bigip_username       = "admin"
        bigip_password       = var.bip.bigip_password
        ec2_key_name         = var.aws_build.keyname
        ec2_username         = "ubuntu"
        log_pool             = cidrhost(cidrsubnet(var.aws_build.cidr, 8, count.index + var.aws_build.internal_subnet_offset), 250)
        juiceshop_virtual_ip = element(flatten(data.aws_network_interface.bar[count.index].private_ips), 1)
        grafana_virtual_ip   = element(flatten(data.aws_network_interface.bar[count.index].private_ips), 2)
        appserver_gateway_ip = cidrhost(cidrsubnet(var.aws_build.cidr, 8, count.index + var.aws_build.internal_subnet_offset), 1)
        appserver_guest_ip   = var.anisble.docker_private_ip[count.index]
      }
    )

    destination = "~/inventory.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.aws_build.keyname}.pem")
      host        = var.anisble.jumphost[count.index]
    }
  }
}
#
# Hack for remote exec of provisioning
#
resource "null_resource" "ansible" {
  depends_on = [null_resource.hostvars]
  count      = length(var.aws_build.azs)
  provisioner "file" {
    source      = "${var.aws_build.keyname}.pem"
    destination = "~/${var.aws_build.keyname}.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.aws_build.keyname}.pem")
      host        = var.anisble.jumphost[count.index]
    }
  }
  # TODO cloning branch for cloud-init updates in base
  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/${var.aws_build.keyname}.pem",
      "git clone -b cloud-init --single-branch https://github.com/merps/ansible-uber-demo.git",
      "cp ~/inventory.yml ~/ansible-uber-demo/ansible/inventory.yml",
      "cd ~/ansible-uber-demo/",
      "ansible-galaxy install -r ansible/requirements.yml",
      "sudo ansible-playbook ansible/playbooks/site.yml"
    ]

    connection {
      type        = "ssh"
      timeout     = "10m"
      user        = "ubuntu"
      private_key = file("${var.aws_build.keyname}.pem")
      host        = var.anisble.jumphost[count.index]
    }
  }
}