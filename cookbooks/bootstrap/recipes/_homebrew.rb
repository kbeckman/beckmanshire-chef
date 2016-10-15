homebrew_user = node[cookbook_name]['user']

# Requirement for "homebrew" recipe...
# https://github.com/chef-cookbooks/homebrew
directory '/usr/local' do
  owner   homebrew_user
  group   'admin'
  mode    '0755'
end

include_recipe 'homebrew'
include_recipe 'homebrew::install_formulas'

# Required to correctly set the file permissions on /Users/<homebrew_user>/Library/Caches/Homebrew/Cask...
# Without this command, brew-cask cannot download the necessary binary packages to the cache folder.
cache_dir_exists = Dir.exists?("/Users/#{homebrew_user}/Library/Caches/Homebrew/Cask")
execute 'brew_uninstall_cask' do
  user    homebrew_user
  command 'brew uninstall --force brew-cask'
  not_if { cache_dir_exists }
end

execute 'brew_cleanup' do
  user    homebrew_user
  command 'brew cleanup'
  not_if { cache_dir_exists }
end

execute 'brew_cask_cleanup' do
  user    homebrew_user
  command 'brew cask cleanup'
  not_if { cache_dir_exists }
end

include_recipe 'homebrew::install_casks'

execute 'brew_prune' do
  user    homebrew_user
  command 'brew prune'
end
