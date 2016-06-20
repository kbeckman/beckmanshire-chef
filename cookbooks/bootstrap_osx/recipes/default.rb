osx_user  = node['bootstrap_osx']['osx_user']

# Requirement for "homebrew" recipe...
# https://github.com/chef-cookbooks/homebrew
directory '/usr/local' do
  owner   osx_user
  group   'admin'
  mode    '0755'
end
