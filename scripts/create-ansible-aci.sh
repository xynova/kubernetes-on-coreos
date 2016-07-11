#! /bin/bash

set -e

DOCKER_IMAGE=node.local/ansible:latest
BUILD_DIR=$HOME/.aci-build 
DOCKER2ACI_IMAGE=docker.io/themalkolm/docker-docker2aci:0.11.1
OUTPUT_ACI=$BUILD_DIR/node.local-ansible-latest.aci


# ----------
# Download ansible docker image and install netaddr module

cat << EOF | docker build -t $DOCKER_IMAGE -
FROM docker.io/williamyeh/ansible:debian8

RUN apt-get update && apt-get install -y python-dev build-essential python-pip
RUN pip install netaddr

EOF


# ----------
# Create .aci from docker image

mkdir -p $BUILD_DIR

echo Step 4 :  Save docker image to disk
docker save -o $BUILD_DIR/ansible.docker $DOCKER_IMAGE

echo Step 5 : Create .aci from docker image
docker run --rm -v $BUILD_DIR:$BUILD_DIR --workdir $BUILD_DIR $DOCKER2ACI_IMAGE /bin/bash -c 'docker2aci ansible.docker' \
 && sudo chown core:core $OUTPUT_ACI

echo Step 6 : Import .aci into rkt
rkt fetch --insecure-options=image file://$OUTPUT_ACI

echo Step 7 : Cleanup
rm -Rf $BUILD_DIR



