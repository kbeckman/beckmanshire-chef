#!/usr/bin/env bash

environment='beckmanshire'
if [[ $(hostname) == "vm-"* ]]; then
  environment='virtual-machine'
fi

sudo chef-client -z \
  -c ~/.chef_zero/chef_zero.rb \
  -j ~/.chef_zero/nodes/$(hostname).json \
  -E ${environment} \
  -N $(hostname)
