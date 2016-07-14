#! /bin/bash

mkdir -p /opt/bin 
ln -sf --no-target-directory /tmp/kubernetes-on-coreos/scripts/run-playbook.sh /opt/bin/run-playbook
ln -sf --no-target-directory /tmp/kubernetes-on-coreos/scripts/run-module.sh /opt/bin/run-module
ln -sf --no-target-directory /tmp/kubernetes-on-coreos/scripts/prepare-ansible.sh /opt/bin/prepare-ansible
