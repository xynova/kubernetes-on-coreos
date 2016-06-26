#! /bin/bash

export KUBECONFIG="${KUBECONFIG}:$(pwd)/kubeconfig" 
kubectl config use-context vagrant-multi
