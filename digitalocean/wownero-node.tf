## Create a new ssh key
resource "digitalocean_ssh_key" "terraform" {
  name       = "Wownero-Node"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

## Create a new Digital Ocean Droplet using the SSH key
resource "digitalocean_droplet" "Wownero-Node-Droplet" {
  name     = "Wownero-Node-Droplet"
  image    = "ubuntu-20-04-x64"
  size     = "s-1vcpu-1gb"
  region   = "nyc3"
  ssh_keys = ["${digitalocean_ssh_key.terraform.fingerprint}"]
  provisioner "remote-exec" {
    command = "echo HELLO"
  }
}
