resource "digitalocean_droplet" "Wownero-Node" {
  image = "ubuntu-20-04-x64" #requirement
  name = "Wownero-Node-Test" #node name
  region = "nyc3" #config to your liking
  size = "s-1vcpu-1gb" # config to your liking
  private_networking = true
#  ssh_keys = [
#    data.digitalocean_ssh_key.terraform.id
#  ]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

#  provisioner "remote-exec" {
#    inline = [
#      # declare the bash shell to be used
#      "export PATH=$PATH:/usr/bin",
#      # clone wownero-node-terraform repo using a bash command cause it's sloppy and fast. will update later
#      "sudo git clone https://github.com/Michael-Free/wownero-node-terraform.git /root/wownero-node-terraform",
#      "sudo chmod +x /root/wownero-node-terraform/install-remote/install-wownero.sh",
#      "sudo ./install-wownero.sh"
#    ]
#  }
}
