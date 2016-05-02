#
# Cookbook Name:: bootstrap_osx
# Recipe::        brew_link_openssl
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


execute 'homebrew link openssl' do
  user 'kbeckman'
  command 'brew link --force openssl'
end

# Requirement for installing rubies (after using brew to install openssl)...
directory '/etc/openssl' do
  owner   'kbeckman'
  group   'admin'
  mode    '0755'
end
