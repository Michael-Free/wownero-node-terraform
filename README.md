# wownero-node-terraform
As it stands right now, I have a basic Terraform script for anyone to spin up a Wownero Node on Digital Ocean. It requires some information for you to input into a file first, before deploying it and you will find this out when following though this documentation.

## Installing Terraform
Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. This includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc. Terraform can manage both existing service providers and custom in-house solutions.
 
  Source: https://www.terraform.io/intro/index.html

### Installing on Linux-based Systems
The Terraform packages are signed using a private key controlled by HashiCorp, so in most situations the first step would be to configure your system to trust that HashiCorp key for package authentication. For example:

```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
```

After registering the key, you can add the official HashiCorp repository to your system:

```
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
``` 

The above command line uses the following sub-shell commands:

`dpkg --print-architecture` to determine your system's primary APT architecture/ABI, such as amd64.
`lsb_release -cs` to find the distribution release codename for your current system, such as buster, groovy, or sid.
`apt-add-repository` usually automatically runs apt update as part of its work in order to fetch the new package indices, but if it does not then you will need to so manually before the packages will be available.

To install Terraform from the new repository:

```
sudo apt install terraform
```

Source: https://www.terraform.io/docs/cli/install/apt.html

### Installing on Windows-based Systems
If you want to deploy a Wownero Node using Terraform using these instructions - please install it following these instructions below. It includes installing Chocolatey as a package manager, and then installing Terraform. After this - we'll be able to deploy a Wownero Node on Digital Ocean using instuctions followed in other steps.

#### Install Chocolatey
Chocolatey is a package manager for Windows that builds on top of existing Windows technologies, using NuGet for packaging. A package manager, for those not familiar, is a way to get software onto your machine without much work on your part. It???s the Windows equivalent of yum or apt-get. Chocolatey downloads applications from their official distribution point and then installs, upgrades, uninstalls and configures them silently on your machine, including dependencies, per the instructions in the package.

  Source: https://puppet.com/blog/chocolatey-what-it/
  
##### Steps to Install chocolatey/choco on Windows 10
The easiest way to install Terraform on Windows 7/10/11 is through using the Chocolatey package manager. Here we will go through the install process of installing Chocolatey and then we will move on to installing Terraform on your local system.
1. Click Start and type ???powershell???
2. Right-click Windows Powershell and choose ???Run as Administrator???
3. Paste the following command into Powershell and press enter. 
  ```
  Set-ExecutionPolicy Bypass -Scope Process -Force; `iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
  ```
4. Answer Yes when prompted
5. Close and reopen an elevated PowerShell window to start using choco
6. Choco is now installed and can be used from a PowerShell prompt or a regular command prompt windows to install many different software packages. Whichever one you use, just make sure you run choco from an elevated powershell/command prompt window.

  Source: https://jcutrer.com/windows/install-chocolatey-choco-windows10
  
##### Install Terraform
Now that we have installed chocolatey - we can now install terraform which is a simple command to run in PowerShell.  Please make sure you run this as Administator and not as a regular user of the system before runing this!

```
choco install terraform
```

## Configuring Terraform files

### Clone this Repo
First thing we want to do now is clone this repo: `git clone https://github.com/Michael-Free/wownero-node-terraform.git`

### Modify vars.auto.tfvars File
The next thing we want to do is navigate to the `/providers/DigitalOcean` directory in the repo we just clone. We will want to modify the `vars.auto.tfvars` file.  There are only 2 variables that we will want to modify here:

```
do_token = "$DIGITALOCEAN_TOKEN"
pvt_key = "$SSHKEY_LOCATION"
```

We will want to find the Digital Ocean Personal Access Token and input it into the `do_token` space.  If you require any assistance in creating or finding this file - please follow along here: https://docs.digitalocean.com/reference/api/create-personal-access-token/. 

This token is used for provisioning resources in Digital Ocean's cloud.

The other variable is `pvt_key`.  This is the ssh key that will be used on the vm to access the terminal of it. This will be on your local machine. If you don't have one setup - you can create one and following with the instructions here: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent.

After this is done, save the file and exit out of your text editor of choice.

### Modify main.tf File
Modify the main.tf with the appropriate region, hostname, etc that you want for the Node.

```
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
```
#### Name Options

#### Size Options
There are different sizes of VMs you can start with.  For the cheapest plan, and what seems to work the best for this scenario (albeit slower) - This can be modified if you'd like.

```
  size     = "s-1vcpu-1gb"
```

The way the coding works on this is that `s-` stands for shared. This is used for 1 to 8 vCPUs. So this could change the next section of the input.  `s-1vcpu`, `s-2vcpu`, `s-3vcpu`, etc all work for this. This also affects the last part of this statement where it works it works up to 16gb of RAM. Beyond this, the first part of this will change to `d-` for dedicated cpu/ram/storage. For more inforamtion please refer to Digital Ocean's plans and pricing listed here: https://docs.digitalocean.com/products/droplets/

#### Region Options
The current setup in this repo sets this as NYC3 as seen below:
```
  region   = "nyc3"
```

But here is a full list of options you can use for regions around the world to setup.  Simply change NYC3 to whatever region you like!

```
NYC1, NYC2, NYC3: New York City, United States
AMS2, AMS3: Amsterdam, the Netherlands
SFO1, SFO2: San Francisco, United States
SGP1: Singapore
LON1: London, United Kingdom
FRA1: Frankfurt, Germany
TOR1: Toronto, Canada
BLR1: Bangalore, India
```

## Deploying with Terraform
Now that we have everything configured in our `auto.vars.tfvars` and `main.tf` files, we'll finally be able to deploy terraform to the Digital Ocean cloud!  Simply fire up a terminal of your choice.  Change directory to where we've cloned under the providers folder (`wownero-node-terraform/providers/DigitalOcean/`) and perform this command:

```
terraform init
```
This command performs several different initialization steps in order to prepare the current working directory for use with Terraform. More details on these are in the sections below, but in most cases it is not necessary to worry about these individual steps.

This command is always safe to run multiple times, to bring the working directory up to date with changes in the configuration. Though subsequent runs may give errors, this command will never delete your existing configuration or state.

Source: https://www.terraform.io/docs/cli/commands/init.html

The next thing we want to do is validate our Terraform setup to make sure this will run as expected:

```
terraform validate
```
The terraform validate command validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.

Validate runs checks that verify whether a configuration is syntactically valid and internally consistent, regardless of any provided variables or existing state. It is thus primarily useful for general verification of reusable modules, including correctness of attribute names and value types.

It is safe to run this command automatically, for example as a post-save check in a text editor or as a test step for a re-usable module in a CI system.

Source: https://www.terraform.io/docs/cli/commands/validate.html

Once we have validated, we want to perform a plan command.  This will help us go through each step of the process to make sure when we execute the terraform script, it will function as expected:

```
terraform plan
```
The terraform plan command creates an execution plan. By default, creating a plan consists of:

 - Reading the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
 - Comparing the current configuration to the prior state and noting any differences.
 - Proposing a set of change actions that should, if applied, make the remote objects match the configuration.

The plan command alone will not actually carry out the proposed changes, and so you can use this command to check whether the proposed changes match what you expected before you apply the changes or share your changes with your team for broader review.

If Terraform detects that no changes are needed to resource instances or to root module output values, terraform plan will report that no actions need to be taken.

Source: https://www.terraform.io/docs/cli/commands/plan.html

Now that we have initialized terraform, validated it, and planned the deployment - It's time to  apply the plan and deploy it directly to the cloud!

```
terraform apply
```
The terraform apply command executes the actions proposed in a Terraform plan.

The most straightforward way to use terraform apply is to run it without any arguments at all, in which case it will automatically create a new execution plan (as if you had run terraform plan) and then prompt you to approve that plan, before taking the indicated actions.

Another way to use terraform apply is to pass it the filename of a saved plan file you created earlier with terraform plan -out=..., in which case Terraform will apply the changes in the plan without any confirmation prompt. This two-step workflow is primarily intended for when running Terraform in automation.

Source: https://www.terraform.io/docs/cli/commands/apply.html
