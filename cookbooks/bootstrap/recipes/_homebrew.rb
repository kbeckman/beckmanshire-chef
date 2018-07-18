homebrew_user = node[cookbook_name]['user']

include_recipe 'homebrew'
include_recipe 'homebrew::install_formulas'
include_recipe 'homebrew::install_casks'

execute 'brew_prune' do
  user    homebrew_user
  command 'brew prune'
end

execute 'brew_cleanup' do
  user    homebrew_user
  command 'brew cleanup'
end

execute 'brew_cask_cleanup' do
  user    homebrew_user
  command 'brew cask cleanup'
end
