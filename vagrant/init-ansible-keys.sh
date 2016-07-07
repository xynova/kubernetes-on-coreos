#! /bin/bash
set -e

# Exit script if it is not run at the same level the Vagrant file lives in
ls | grep -q Vagrantfile || (echo "Must be run at the Vagrantfile level" && exit 1)

# Validate .ssh directory exists (windows compatibility)
ls -a | grep -q .ssh || mkdir .ssh

# Create private ssh key if it doesn't exist yet
ls .ssh | grep -q id_rsa || ssh-keygen -b 2048 -t rsa -f .ssh/id_rsa -q -N ''

# Enable ansible keys from vagrant host
rm -Rf ../.ssh && ln -sf $(pwd)/.ssh ../.ssh 
