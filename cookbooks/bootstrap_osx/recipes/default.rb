#
# Cookbook Name:: bootstrap
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# Requirement for "homebrew" recipe...
directory '/usr/local' do
  owner 'kbeckman'
  group 'admin'
  mode '0755'
end