data "aws_network_interface" "f5_nic" {
  count = length(var.f5.bigip.public_nic_ids)
  id    = var.f5.bigip.public_nic_ids[count.index]
}
locals {
  prefix = "${var.aws_build.project}-${var.aws_build.env}"
}
#
# Create and place the inventory.yml file for the ansible demo
#
resource "null_resource" "hostvars" {
  count = length(var.azs)
  provisioner "file" {
    content = templatefile(
      "${path.module}/files/hostvars_template.yml",
      {
        bigip_host_ip        = join(",", [element(flatten(var.f5.bigip.mgmt_addresses), count.index)])
        bigip_username       = var.bigip_admin
        bigip_password       = tostring(var.f5.admin_pw)
        ec2_key_name         = var.aws_build.keypair
        ec2_username         = var.ec2_user
        log_pool             = cidrhost(cidrsubnet(var.vpc.vpc_cidr_block, 8, count.index + var.internal_subnet_offset), 250)
        juiceshop_virtual_ip = element(flatten(data.aws_network_interface.f5_nic[count.index].private_ips),1)
        grafana_virtual_ip   = element(flatten(data.aws_network_interface.f5_nic[count.index].private_ips),2)
        appserver_gateway_ip = cidrhost(cidrsubnet(var.vpc.vpc_cidr_block, 8, count.index + var.internal_subnet_offset), 1)
        appserver_guest_ip   = var.ansible.docker_private_ip[count.index]
      }
    )
    destination = "/home/ubuntu/inventory.yml"

    connection {
      type        = "ssh"
      user        = var.ec2_user
      private_key = file("${var.aws_build.keypair}.pem")
      host        = var.ansible.jumphost.jumphost_public_ip[count.index]
    }
  }
}
#
# Create interface for BIG-IP virtual server - juiceshop
#
resource "aws_eip" "juiceshop" {
  # an occasional race condition with between creating the ElasticIP addresses
  # and the BIG-IP instances occurs causing the following error
  # Error: Failure associating EIP: IncorrectInstanceState: The pending-instance-creation instance to which
  # 'eni-xxxxxxxxxxxxxxxxx' is attached is not in a valid state for this operation
  # https://github.com/terraform-providers/terraform-provider-aws/issues/6189
  # the following depends_on is intended as a workaround for this condition
  # if the error still occurs an additional 'terraform apply' completes the environment build
  depends_on                = [null_resource.hostvars]
  count                     = length(var.azs)
  vpc                       = true
  network_interface         = data.aws_network_interface.f5_nic[count.index].id
  associate_with_private_ip = element(flatten(data.aws_network_interface.f5_nic[count.index].private_ips), 1)
  tags = {
    Name = format("%s-juiceshop-eip-%s%s", local.prefix, var.aws_build.random, count.index)
  }
}
#
# Create interface for BIG-IP virtual server - grafana
#
resource "aws_eip" "grafana" {
    # an occasional race condition with between creating the ElasticIP addresses
  # and the BIG-IP instances occurs causing the following error
  # Error: Failure associating EIP: IncorrectInstanceState: The pending-instance-creation instance to which
  # 'eni-xxxxxxxxxxxxxxxxx' is attached is not in a valid state for this operation
  # https://github.com/terraform-providers/terraform-provider-aws/issues/6189
  # the following depends_on is intended as a workaround for this condition
  # if the error still occurs an additional 'terraform apply' completes the environment build
  depends_on                = [null_resource.hostvars]
  count                     = length(var.azs)
  vpc                       = true
  network_interface         = data.aws_network_interface.f5_nic[count.index].id
  associate_with_private_ip = element(flatten(data.aws_network_interface.f5_nic[count.index].private_ips), 2)
  tags = {
    Name = format("%s-grafana-eip-%s%s", local.prefix, var.aws_build.random, count.index)
  }
}
#
# Hack for remote exec of provisioning
#
resource "null_resource" "ansible" {
  depends_on = [null_resource.hostvars]
  count      = length(var.azs)
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
  # TODO cloning branch for cloud-init updates in base - THERE BE MADNESS!!!
  #
  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/${var.ec2_user}/${var.aws_build.keypair}.pem",
      "git clone -b cloud-init --single-branch https://github.com/merps/ansible-uber-demo.git",
      "cp /home/ubuntu/inventory.yml /home/ubuntu/ansible-uber-demo/ansible/inventory.yml",
      "cd /home/ubuntu/ansible-uber-demo/",
      "ansible-galaxy install -r ansible/requirements.yml",
      "ansible-playbook ansible/playbooks/site.yml"
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
