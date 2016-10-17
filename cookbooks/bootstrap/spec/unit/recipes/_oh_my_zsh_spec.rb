# require 'mixlib/shellout'
require 'spec_helper'

RSpec.describe "#{COOKBOOK_NAME}::_oh_my_zsh" do
  let(:user) { 'jduggan' }
  let(:which_bash) { '/bin/bash' }
  let(:which_zsh) { '/usr/local/bin/zsh' }
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal[COOKBOOK_NAME]['user'] = user
    end.converge(described_recipe)
  end

  before(:each) do
    which_zsh_double = double('which_zsh_double')
    allow(which_zsh_double).to receive(:run_command)
    allow(which_zsh_double).to receive(:error!)
    allow(which_zsh_double).to receive(:stdout).and_return(which_zsh)
    allow(Mixlib::ShellOut).to receive(:new).with('which zsh').and_return(which_zsh_double)

    shell_double = double('shell_double')
    allow(shell_double).to receive(:run_command)
    allow(shell_double).to receive(:error!)
    allow(shell_double).to receive(:stdout).and_return(which_zsh )
    allow(Mixlib::ShellOut).to receive(:new).with('echo $SHELL').and_return(shell_double)
  end

  describe 'execute[change_shell_to_zsh]:' do
    context 'shell is not ZSH' do
      before(:each) do
        shell_double = double('shell_double')
        allow(shell_double).to receive(:run_command)
        allow(shell_double).to receive(:error!)
        allow(shell_double).to receive(:stdout).and_return(which_bash)
        allow(Mixlib::ShellOut).to receive(:new).with('echo $SHELL').and_return(shell_double)
      end

      it "executes 'change_shell_to_zsh'" do
        expect(chef_run).to run_execute('change_shell_to_zsh').with({ command: "chsh -s #{which_zsh} #{user}" })
      end
    end

    context 'shell is already ZSH' do
      it "does not execute 'change_shell_to_zsh'" do
        expect(chef_run).to_not run_execute('change_shell_to_zsh')
      end
    end
  end

  describe 'remote_file[ohmyzsh_installer]:' do
    context '/Users/[user]/.oh-my-zsh does not exist' do
      before(:each) { allow(Dir).to receive(:exists?).with("/Users/#{user}/.oh-my-zsh").and_return(false)}

      it "executes 'ohmyzsh_installer'" do
        expect(chef_run).to create_remote_file('ohmyzsh_installer').
          with({ path: '/tmp/install-ohmyzsh.sh', source: 'http://install.ohmyz.sh', mode: '0777' })
      end
    end

    context '/Users/[user]/.oh-my-zsh exists' do
      before(:each) { allow(Dir).to receive(:exists?).with("/Users/#{user}/.oh-my-zsh").and_return(true)}

      it "doesn't execute 'ohmyzsh_installer'" do
        expect(chef_run).to_not create_remote_file('ohmyzsh_installer')
      end
    end
  end

  describe 'bash[install_ohmyzsh]:' do
    let(:subject) { chef_run.bash('install_ohmyzsh') }

    it 'is configured but does nothing until notified' do
      expect(subject).to          do_nothing
      expect(subject.cwd).to eq   '/tmp'
      expect(subject.code).to eq  './install-ohmyzsh.sh'
    end

    it 'subscribes to remote_file[ohmyzsh_installer]' do
      expect(subject).to subscribe_to('remote_file[ohmyzsh_installer]').on(:create).immediately
    end
  end
end
