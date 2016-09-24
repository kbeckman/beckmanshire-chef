osx_user  = node['bootstrap_osx']['osx_user']

execute 'homebrew link openssl' do
  user    osx_user
  command 'brew link --force openssl'
end

# Requirement for installing rubies (after using brew to install openssl)...
directory '/etc/openssl' do
  owner   osx_user
  group   'admin'
  mode    '0755'
end
