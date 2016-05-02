#
# Cookbook Name:: bootstrap
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# Requirement for "homebrew" recipe...
# https://github.com/chef-cookbooks/homebrew
directory '/usr/local' do
  owner   'kbeckman'
  group   'admin'
  mode    '0755'
end
