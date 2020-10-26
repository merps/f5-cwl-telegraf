# Testing Outputs
output "docker_private_ip" {
  value = "${data.terraform_remote_state.infra.outputs.docker-host.0}"
}