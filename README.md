# wownero-node-terraform
Basic terraform install script for a wownero node

#WIP

# Milestones
- Simple, unsophisticated bash script `install-wownero.sh` to install wownero daemon, create a service for wownero, apply a configuration file, and exit with a successful return code. this script will run directly on the remote host, after being cloned from this repo's git url.
- `install-wownero.sh` should only be for Ubuntu Server 20.04 LTS at the moment
- Creating a successful terraform provider configuration for DigitalOcean
- Creating a terraform plan that installs `install-wownero.sh` and sucessully starts a wownero node
- Creating a terraform plan that installs a wownero node service completely with terraform and no bash scripts.
