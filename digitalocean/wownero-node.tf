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
}

#  provisioner "remote-exec" {
#    inline = [
#      "export PATH=@$PATH:/usr/bin",
#      "pwd"
#    ]
#  }
#  connection {
#    type = "ssh"
#    user = "root"
#    private_key="${file("~/.ssh/id_rsa)}"
#  }
#}

#provisioner "remote-exec" {
#  inline = [
#    # declare the bash shell to be used
#    "export PATH=$PATH:/usr/bin",
#    # clone wownero-node-terraform repo using a bash command cause it's sloppy and fast. will update later
#    "sudo git clone https://github.com/Michael-Free/wownero-node-terraform.git /root/wownero-node-terraform",
#    "sudo chmod +x /root/wownero-node-terraform/install-remote/install-wownero.sh",
#    "sudo ./install-wownero.sh"
#  ]
#}
