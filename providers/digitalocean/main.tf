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
    host = self.ipv4_address
    user = "root"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
  provisioner "file" {
    source = "wownero.conf"
    destination = "/tmp/wownero.conf"
  }
  provisioner "file" {
    source = "wownero.service"
    destination = "/tmp/wownero.service"
  }
  provisioner "file" {
    source = "install-wownero.sh"
    destination = "/tmp/install-wownero.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-wownero.sh",
      "mkdir /root/wownero/",
      "apt update && apt install apt-transport-https -y",
      "wait",
      #"wget -q -O - https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | apt-key add -",
      #"echo 'deb https://deb.torproject.org/torproject.org $(lsb_release -cs) main' | sudo tee -a /etc/apt/sources.list",
      "apt update && apt install tor -y",
      "wait",
      #"apt install tor -y",
      #"curl -J -L https://git.wownero.com/attachments/e9e6fa73-9e3a-4391-af04-64fba8cc6d9e --output /tmp/wownero.deb",
      #"dpkg -i /tmp/wownero.deb",
      #"cat /tmp/wownero.service > /etc/systemd/system/wownero.service",
      #"cat /tmp/wownero.conf > /root/wownero.conf",
      #"systemctl daemon-reload",
      #"systemctl start wownero.service",
      #"systemctl enable wownero.service",
      #"/tmp/install-wownero.sh",
    ]
  }
}
