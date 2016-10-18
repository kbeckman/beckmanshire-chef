include_recipe "#{cookbook_name}::_default"
include_recipe "#{cookbook_name}::_homebrew"
include_recipe 'rvm::user'
include_recipe "#{cookbook_name}::_oh_my_zsh"
include_recipe "#{cookbook_name}::_homesick"

reboot 'reboot_system' do
  reason      'End of chef-client run...'
  delay_mins  0
  action      :request_reboot
end
