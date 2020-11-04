data "aws_network_interface" "bar" {
  count = length(var.bigip.bigip.ext.public_nic_ids)
  id    = var.bigip.bigip.ext.public_nic_ids[count.index]
}
locals {
  prefix = tostring("${var.aws_build.project}-${var.aws_build.env}")
}
#
# Create interface for BIG-IP virtual server - juiceshop
#
resource "aws_eip" "juiceshop" {
  depends_on                = [null_resource.hostvars]
  count                     = length(var.vpc.public_subnets)
  vpc                       = true
  network_interface         = data.aws_network_interface.bar[count.index].id
  associate_with_private_ip = element(flatten(data.aws_network_interface.bar[count.index].private_ips), 1)
  tags = {
    Name = format("%s-juiceshop-eip-%s%s", local.prefix, var.aws_build.random, count.index)
  }
}
#
# Create interface for BIG-IP virtual server - grafana
#
resource "aws_eip" "grafana" {
  depends_on                = [null_resource.hostvars]
  count                     = length(var.vpc.public_subnets)
  vpc                       = true
  network_interface         = data.aws_network_interface.bar[count.index].id
  associate_with_private_ip = element(flatten(data.aws_network_interface.bar[count.index].private_ips), 2)
  tags = {
    Name = format("%s-grafana-eip-%s%s", local.prefix, var.aws_build.random, count.index)
  }
}
#
# Create and place the inventory.yml file for the ansible demo
#

resource "null_resource" "hostvars" {
  count = length(var.vpc.public_subnets)
  provisioner "file" {
    content = templatefile(
      "${path.module}/files/hostvars_template.yml",
      {
        bigip_host_ip        = join(",", [element(var.bigip.bigip.mgmt.ip, count.index)])
        bigip_username       = "admin"
        bigip_password       = tostring(var.bigip.bigip.admin_pw)
        ec2_key_name         = var.aws_build.keypair
        ec2_username         = "ubuntu"
        log_pool             = cidrhost(cidrsubnet(var.vpc.vpc_cidr_block, 8, count.index + var.internal_subnet_offset), 250)
        juiceshop_virtual_ip = element(flatten(data.aws_network_interface.bar[count.index].private_ips), 1)
        grafana_virtual_ip   = element(flatten(data.aws_network_interface.bar[count.index].private_ips), 2)
        appserver_gateway_ip = cidrhost(cidrsubnet(var.vpc.vpc_cidr_block, 8, count.index + var.internal_subnet_offset), 1)
        appserver_guest_ip   = var.ansible.docker_private_ip[count.index]
      }
    )

    destination = "~/inventory.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.aws_build.keypair}.pem")
      host        = var.ansible.jumphost.jumphost_public_ip[count.index]
    }
  }
}
#
# Hack for remote exec of provisioning
#
resource "null_resource" "ansible" {
  depends_on = [null_resource.hostvars]
  count      = length(var.vpc.public_subnets)
  provisioner "file" {
    source      = "${var.aws_build.keypair}.pem"
    destination = "~/${var.aws_build.keypair}.pem"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${var.aws_build.keypair}.pem")
      host        = var.ansible.jumphost.jumphost_public_ip[count.index]
    }
  }
  # TODO cloning branch for cloud-init updates in base
  provisioner "remote-exec" {
    inline = [
      "chmod 600 ~/${var.aws_build.keypair}.pem",
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
      private_key = file("${var.aws_build.keypair}.pem")
      host        = var.ansible.jumphost.jumphost_public_ip[count.index]
    }
  }
}
