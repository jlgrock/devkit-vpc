#!/bin/bash
clear
sudo rm -rf terraform.tfstate* .terraform
sudo podman run -it --rm \
    --name devkit-vpc \
    --entrypoint ./site.yml \
    --workdir /root/deploy/terraform/devkit-vpc \
    --volume $(pwd):/root/deploy/terraform/devkit-vpc:z \
  docker.io/codesparta/konductor