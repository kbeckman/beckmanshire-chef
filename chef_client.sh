#!/usr/bin/env bash

sudo chef-client -z \
  -c ~/.chef_zero/chef_zero.rb \
  -j ~/.chef_zero/nodes/$(hostname).json \
  -E beckmanshire \
  -N $(hostname)
