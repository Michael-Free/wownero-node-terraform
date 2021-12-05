# wownero-node-terraform
As it stands right now, I have a basic Terraform script for anyone to spin up a Wownero Node on Digital Ocean. It requires some information for you to input into a file first, before deploying it and you will find this out when following though this documentation.

## Installing Terraform
Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. This includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc. Terraform can manage both existing service providers and custom in-house solutions.
 
  Source: https://www.terraform.io/intro/index.html

### Installing on Linux-based Systems

### Installing on Windows-based Systems

### Install Chocolatey
Chocolatey is a package manager for Windows that builds on top of existing Windows technologies, using NuGet for packaging. A package manager, for those not familiar, is a way to get software onto your machine without much work on your part. It’s the Windows equivalent of yum or apt-get. Chocolatey downloads applications from their official distribution point and then installs, upgrades, uninstalls and configures them silently on your machine, including dependencies, per the instructions in the package.

  Source: https://puppet.com/blog/chocolatey-what-it/

# This is still a work in progress
- setup and configuration of azure provider configuration for azure
- use local ssh key instead of new key for new azure vm
- use basic azure configturation
- create vars.auto.tfvars for azure and implement them in to azure configuration
- 
