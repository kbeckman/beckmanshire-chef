user = node[cookbook_name]['user']

which_zsh_cmd = 'which zsh'
cmd           = Mixlib::ShellOut.new(which_zsh_cmd)
cmd.run_command && cmd.error!
which_zsh = cmd.stdout.rstrip

shell_cmd = 'echo $SHELL'
cmd       = Mixlib::ShellOut.new(shell_cmd)
cmd.run_command && cmd.error!
shell = cmd.stdout.rstrip

ohmyzsh_exists = Dir.exists?("/Users/#{user}/.oh-my-zsh")

execute 'change_shell_to_zsh' do
  command "chsh -s #{which_zsh} #{user}"
  not_if  { shell =~ /zsh/ }
end

remote_file 'ohmyzsh_installer' do
  path    '/tmp/install-ohmyzsh.sh'
  source  'http://install.ohmyz.sh'
  mode    '0777'
  not_if  { ohmyzsh_exists }
end

bash 'install_ohmyzsh' do
  cwd         '/tmp'
  code        './install-ohmyzsh.sh'
  action      :nothing
  subscribes  :create, 'remote_file[ohmyzsh_installer]', :immediately
end
