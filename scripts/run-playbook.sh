#! /bin/bash
set -e

RKT_IMAGE=node.local/ansible:latest
BASEDIR=$(dirname $(readlink -f $0))

# Check if ansible rkt image is available
rkt image list | grep -q $RKT_IMAGE || (echo "The ansible container does not exist. Build by executing the 'prepare-ansible' command first" && exit 1)

# Run rkt ansible image
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
  $RKT_IMAGE --exec '/bin/bash' -- -c 'cd /root/workdir && ansible-playbook '$@  

