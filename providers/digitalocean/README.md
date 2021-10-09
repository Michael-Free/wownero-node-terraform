Make sure terraform is installed on your Linux system

Modify vars.auto.tfvars with the digital ocean key that's needed for provisioning vms in the cloud.

Modify the main.tf with the appropriate region, hostname, etc that you want for the Node.

Perform terraform init

Perform terraform validate to ensure setup is valid

Perform terraform plan to get an idea of what will happen

Perform terraform apply to spin up the node in the digital ocean
