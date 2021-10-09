terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}

provider "digitalocean" {
  token = var.do_token
}
connection {
  type = "ssh"
  user = "root"
  private_key = "${file("~/.ssh/id_rsa")}"
}
provisioner "remote-exec" {
  inline = [
    "export PATH=$PATH:/usr/bin"
  ]
}
#data "digitalocean_ssh_key" "terraform" {
#  name = "terraform"
#}
