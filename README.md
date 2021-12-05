# wownero-node-terraform
As it stands right now, I have a basic Terraform script for anyone to spin up a Wownero Node on Digital Ocean. It requires some information for you to input into a file first, before deploying it and you will find this out when following though this documentation.

## Installing Terraform
Terraform is an infrastructure as code (IaC) tool that allows you to build, change, and version infrastructure safely and efficiently. This includes low-level components such as compute instances, storage, and networking, as well as high-level components such as DNS entries, SaaS features, etc. Terraform can manage both existing service providers and custom in-house solutions.
 
  Source: https://www.terraform.io/intro/index.html

### Installing on Linux-based Systems

### Installing on Windows-based Systems
If you want to deploy a Wownero Node using Terraform using these instructions - please install it following these instructions below. It includes installing Chocolatey as a package manager, and then installing Terraform. After this - we'll be able to deploy a Wownero Node on Digital Ocean using instuctions followed in other steps.

#### Install Chocolatey
Chocolatey is a package manager for Windows that builds on top of existing Windows technologies, using NuGet for packaging. A package manager, for those not familiar, is a way to get software onto your machine without much work on your part. It’s the Windows equivalent of yum or apt-get. Chocolatey downloads applications from their official distribution point and then installs, upgrades, uninstalls and configures them silently on your machine, including dependencies, per the instructions in the package.

  Source: https://puppet.com/blog/chocolatey-what-it/
##### Steps to Install chocolatey/choco on Windows 10
The easiest way to install Terraform on Windows 7/10/11 is through using the Chocolatey package manager. Here we will go through the install process of installing Chocolatey and then we will move on to installing Terraform on your local system.
1. Click Start and type “powershell“
2. Right-click Windows Powershell and choose “Run as Administrator“
3. Paste the following command into Powershell and press enter. 
  ``Set-ExecutionPolicy Bypass -Scope Process -Force; `iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))``
5. Answer Yes when prompted
6. Close and reopen an elevated PowerShell window to start using choco
7. Choco is now installed and can be used from a PowerShell prompt or a regular command prompt windows to install many different software packages. Whichever one you use, just make sure you run choco from an elevated powershell/command prompt window.
  Source: https://jcutrer.com/windows/install-chocolatey-choco-windows10
  
#### Install Terraform
Now that we have installed chocolatey - we can now install terraform which is a simple command to run in PowerShell.  Please make sure you run this as Administator and not as a regular user of the system before runing this!

`choco install terraform`

## Configuring Terraform files

