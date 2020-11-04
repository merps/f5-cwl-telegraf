anisble = {
  docker_private_ip = [
    "10.0.20.38",
    "10.0.21.78"
  ],
  jumphost = [
    "54.206.195.70",
    "3.25.167.115"
  ]
}
aws_build = {
  cidr = "10.0.0.0/16",
  prefix = "darkness",
  keyname = "mjk-f5cs-apse2",
  random = "Q4A",
  azs = ["ap-southeast-2a", "ap-southeast-2b"],
  internal_subnet_offset = 20
}

bip = {
  bigip_password = "lBeeMG8Z9RsLN360",
  bigip_mgmt_addr = ["10.0.10.78", "10.0.11.57"],
  public_nic_ids = ["eni-0c9123d51ba75732f", "eni-00562b24a44acdf51"]
}