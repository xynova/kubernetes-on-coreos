#! /bin/bash

sudo rkt run \
  --insecure-options=image \
  --volume ssh-keys,kind=host,source=$HOME/.ssh,readOnly=true \
  --volume ansible-cp,kind=empty,readOnly=false \
  --volume workdir,kind=host,source=$(pwd),readOnly=true \
  --mount volume=ssh-keys,target=/root/.ssh \
  --mount volume=ansible-cp,target=/root/.ansible \
  --mount volume=workdir,target=/root/workdir \
  --net=host \
  --interactive=true \
  docker://williamyeh/ansible:alpine3 --exec 'sh' -- -c 'cd /root/workdir && ansible-playbook '$@  

